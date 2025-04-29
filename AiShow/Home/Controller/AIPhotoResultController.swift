import UIKit

class AIPhotoResultController: BaseVC {
    private let disposeBag = DisposeBag()
    private var selectedImage: UIImage? // 新增选中图片状态
    
    // UI Components
    private var contentTextF = UITextView()
    private let addImgV = UIImageView()
    
    /// 无数据视图
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        let imageView = UIImageView(image: UIImage(named: "icon_no_data"))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.height.equalTo(100)
        }
        
        let label = UILabel()
        label.text = "暂无数据"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        super.initUI()
        setupNavigation()
        setupTextInput()
        setupImagePicker()
        setupGenerateButton()
    }
    
    // MARK: - UI Configuration
    private func setupNavigation() {
        navTitleLabel.text = "图文封面生成"
        view.backgroundColor = .hex(hexString: "#F8F8F8")
    }
    
    private func setupTextInput() {
        let tipLab = UILabel()
        tipLab.text = "笔记文案"
        tipLab.textColor = .hex(hexString: "#282828")
        tipLab.font = .systemFont(ofSize: 15)
        view.addSubview(tipLab)  // 关键添加
        
        tipLab.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(self.navView.snp.bottom).offset(30)
        }
        
        view.addSubview(emptyView)
        // 创建文本视图
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        
        // 创建占位符标签
        let placeholderLabel = UILabel()
        placeholderLabel.text = "输入要生成笔记文案"
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = UIColor.hex(hexString: "#C7C7CC")
        placeholderLabel.isHidden = !textView.text.isEmpty  // 初始状态
        
        // 统一使用RxSwift绑定（删除重复绑定）
        textView.rx.text
            .map { !($0?.isEmpty ?? true) }  // 反转逻辑：有文字时隐藏占位符
            .distinctUntilChanged()
            .bind(to: placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        placeholderLabel.isHidden = !textView.text.isEmpty
        placeholderLabel.tag = 999
        
        // 添加视图和约束
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(14)
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLab.snp.bottom).offset(10)
            make.height.equalTo(180)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
        }
        
        // 使用RxSwift监听文本变化
        // 删除以下重复绑定代码：
        // textView.rx.text
        //    .map { $0?.isEmpty ?? true }
        //    .distinctUntilChanged()
        //    .bind(to: placeholderLabel.rx.isHidden)
        //    .disposed(by: disposeBag)
        
        // 保持引用
        self.contentTextF = textView
    }
    
    private func setupImagePicker() {
        addImgV.image = UIImage(named: "add-copy")
        addImgV.isUserInteractionEnabled = true
        addImgV.contentMode = .scaleAspectFill
        addImgV.clipsToBounds = true
        addImgV.layer.cornerRadius = 8
        addImgV.layer.masksToBounds = true
        
        // 点击手势处理
        addImgV.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let imagePicker = TZImagePickerController(maxImagesCount: 1, delegate: self)!
                imagePicker.allowPickingVideo = false
                imagePicker.allowTakePicture = true // 允许拍摄
                imagePicker.modalPresentationStyle = .fullScreen
                self?.present(imagePicker, animated: true)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(addImgV)
        addImgV.snp.makeConstraints { make in
            make.left.equalTo(contentTextF.snp.left)
            make.top.equalTo(contentTextF.snp.bottom).offset(10)
            make.width.height.equalTo(90)
        }
    }
    
    private func setupGenerateButton() {
        let nextBut = UIButton(type: .custom)
        nextBut.setTitle("开始生成", for: .normal)
        nextBut.backgroundColor = .hex(hexString: "#43bbff")
        nextBut.layer.cornerRadius = 12
        nextBut.layer.masksToBounds = true
        
        // 按钮点击处理
        nextBut.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 输入校验
                guard let text = self.contentTextF.text, !text.isEmpty else {
                    SVProgressHUD.showInfo(withStatus: "请输入笔记文案")
                    return
                }
                
                guard self.selectedImage != nil else {
                    SVProgressHUD.showInfo(withStatus: "请选择图片")
                    return
                }
                
                // 执行生成逻辑
                self.handleGenerateAction()
            })
            .disposed(by: disposeBag)
        
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(addImgV.snp.bottom).offset(30)
            make.leading.equalTo(40)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    private func handleGenerateAction() {
        // 这里添加具体的生成逻辑
        SVProgressHUD.showSuccess(withStatus: "生成请求已发送")
    }
}

// MARK: - TZImagePickerControllerDelegate
extension AIPhotoResultController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let image = photos.first else { return }
        selectedImage = image
        addImgV.image = image
    }
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        SVProgressHUD.showInfo(withStatus: "已取消选择")
    }
}

// MARK: - TextView Delegate
extension AIPhotoResultController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 手动触发RxSwift的文本观察
        textView.rx.text.onNext(textView.text)
    }
}
