import UIKit
import SnapKit

class AIPhotoController: BaseVC {
    private let disposeBag = DisposeBag()
    private let iconImgV = UIImageView()
    private let nextLab = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func initUI() {
        super.initUI()
        
        navTitleLabel.text = "AI Show"
        view.backgroundColor = .hex(hexString: "#F8F8F8")
        
        setupImagePreview()
        setupStatusLabels()
        setupGenerateButton()
    }

    // MARK: - UI Components
    private func setupImagePreview() {
        iconImgV.contentMode = .scaleAspectFill
        iconImgV.sd_setImage(with: URL(string: "https://cdn.dancf.com/fe-assets/img/8f971e4dd51f4a4bde8d6fc65f84b02d.png"))
        view.addSubview(iconImgV)
        
        iconImgV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.centerX.equalToSuperview()
            make.height.equalTo(iconImgV.snp.width).multipliedBy(0.86)
        }
    }

    private func setupStatusLabels() {
        // 状态提示标签
        let tipLab = UILabel()
        tipLab.text = "暂无设计结果"
        tipLab.font = .systemFont(ofSize: 14)
        tipLab.textColor = .hex(hexString: "#7F8792")
        
        view.addSubview(tipLab)
        tipLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(15)
        }
        
        // 操作提示标签
        nextLab.text = " 点击下方按钮，开始生成吧 "
        nextLab.font = .systemFont(ofSize: 14)
        nextLab.textColor = .hex(hexString: "#7F8792")
        view.addSubview(nextLab)
        nextLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tipLab.snp.bottom).offset(5)
        }
    }

    private func setupGenerateButton() {
        let nextBut = UIButton(type: .custom)
            nextBut.setTitle("开始生成", for: .normal)
            nextBut.backgroundColor = .hex(hexString: "#43bbff")
            nextBut.layer.cornerRadius = 8
            
            // 事件订阅保持RxSwift方式
            nextBut.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.handleGenerateAction()
                })
                .disposed(by: disposeBag)
            
            view.addSubview(nextBut)
            nextBut.snp.makeConstraints {
                $0.top.equalTo(nextLab.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.leading.equalToSuperview().offset(50)
                $0.height.equalTo(44)
            }
    }

    // MARK: - Actions
    private func handleGenerateAction() {
        print("开始生成操作")
        
        let vc = AIPhotoResultController()
        vc.hidesBottomBarWhenPushed = true
        
        if var viewControllers = self.navigationController?.viewControllers {
            // 移除当前控制器
            viewControllers.removeAll { $0 == self }
            // 添加新控制器
            viewControllers.append(vc)
            // 设置新的控制器栈
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
}
