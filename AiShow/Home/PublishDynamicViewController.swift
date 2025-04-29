import UIKit
import TZImagePickerController
import RxSwift
import RxCocoa

class PublishDynamicViewController: BaseVC, TZImagePickerControllerDelegate {
    
    private let contentTextView = UITextView()
    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DynamicImageCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var selectedImages: [UIImage] = []
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    
    private func setupNavigation() {
        
        view.backgroundColor = .hex(hexString: "0xf7f7f7")
        navTitleLabel.text = "发布动态"
        navLeftBtn.setTitle("取消", for: .normal)
        navRightBtn.setTitle("发布", for: .normal)
        
        // 绑定按钮事件
        navLeftBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        navRightBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.publishDynamic()
            }).disposed(by: disposeBag)
    }
    
    private var collectionViewHeightConstraint: Constraint? // 新增约束引用
    
    private func setupUI() {
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 8
        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.placeholder = "输入你要发布的内容"
        let addPhotoButton = UIButton(type: .system)
        addPhotoButton.setImage(UIImage(named: "add-copy"), for: .normal)
        addPhotoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.selectPhotos()
            }).disposed(by: disposeBag)
        
        let stackView = UIStackView(arrangedSubviews: [contentTextView, imageCollectionView, addPhotoButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(navView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20) // 新增底部约束
        }
        
        // 修改图片集合视图约束
        imageCollectionView.snp.makeConstraints {
            $0.height.equalTo(0).priority(.low) // 设置基础高度为0（低优先级）
            $0.height.greaterThanOrEqualTo(80).priority(.required) // 最小高度80
            $0.height.lessThanOrEqualTo(200).priority(.required) // 最大高度200
        }
        
        // 设置内容文本框高度自适应
        contentTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(100).priority(.required)
            $0.height.lessThanOrEqualTo(300).priority(.required)
        }
        
        // 设置内容优先级
        contentTextView.setContentHuggingPriority(.required, for: .vertical)
        contentTextView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func selectPhotos() {
        guard let picker = TZImagePickerController(maxImagesCount: 9, delegate: self) else { return }
        picker.didFinishPickingPhotosHandle = { [weak self] photos, _, _ in
            self?.selectedImages = photos ?? []
            self?.imageCollectionView.reloadData()
            self?.updateCollectionViewHeight() // 新增高度更新
        }
        present(picker, animated: true)
    }
    
    private func publishDynamic() {
        guard !contentTextView.text.isEmpty else {
            SVProgressHUD.showError(withStatus: "内容不能为空")
            return
        }
        
        // 构建动态模型（参考现有DynamicModel结构）
        let newDynamic = DynamicModel(
            headImg: UserDefaults.standard.string(forKey: "userHead") ?? "",
            nickNameStr: UserDefaults.standard.string(forKey: "userName") ?? "匿名用户",
            contentStr: contentTextView.text
        )
        
        // 保存到本地（需要扩展DynamicData的保存逻辑）
        saveDynamicToLocal(newDynamic)
        
        SVProgressHUD.show()
        // 网络请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
            SVProgressHUD.dismiss()
            self?.dismiss(animated: true){
                SVProgressHUD.showSuccess(withStatus: "等待审核，稍后再作者中心中展示")
            }
            
//            // 关闭页面
//            dismiss(animated: true) {
//                NotificationCenter.default.post(name: NSNotification.Name("NewDynamicPosted"), object: nil)
//            }
        }
    }
    
    private func saveDynamicToLocal(_ dynamic: DynamicModel) {
        // 需要实现本地存储逻辑（可参考PlazaViewController的loadDynamicData方法）
        // 这里可以保存到UserDefaults或更新本地JSON文件
    }
}

// MARK: - CollectionView DataSource
extension PublishDynamicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    
    // 修改高度更新方法
    private func updateCollectionViewHeight() {
        let itemsPerRow: CGFloat = 4
        let rowCount = ceil(CGFloat(selectedImages.count) / itemsPerRow)
        let newHeight = rowCount * 90 + (rowCount - 1) * 10
        
        // 使用remakeConstraints代替updateConstraints
        imageCollectionView.snp.remakeConstraints {
            $0.height.greaterThanOrEqualTo(80).priority(.high)
            $0.height.lessThanOrEqualTo(200).priority(.high)
            $0.height.equalTo(newHeight.clamped(to: 80...200)).priority(.medium)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DynamicImageCell
        cell.imageView.image = selectedImages[indexPath.item]
        cell.deleteHandler = { [weak self] in
            self?.selectedImages.remove(at: indexPath.item)
            self?.imageCollectionView.reloadData()
        }
        return cell
    }
}

// MARK: - 图片选择Cell
class DynamicImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    private let deleteButton = UIButton()
    var deleteHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        deleteButton.setImage(UIImage(named: "icon_close"), for: .normal)
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.deleteHandler?()
            }).disposed(by: disBag)
        
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 添加数值范围限制扩展
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
