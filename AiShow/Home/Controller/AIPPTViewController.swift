//
//  AIPPTViewController.swift
//  AiShow
//
//  Created by joyo on 2025/4/23.
//

import UIKit

class AIPPTViewController: BaseVC {
    var aiModel : AITool = AITool(icon: "", name: "AI", description: "", tag: 1)

    private var contentTextF = UITextView()
    private var tipTextF = UITextView()
    private var imgBut = UIButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func initUI() {
        super.initUI()
        
        navTitleLabel.text = "AI PPT"
        view.backgroundColor = .hex(hexString: "#F8F8F8")        
        setupTextInput()
        // 发送按钮点击
        imgBut.rx.tap
            .subscribe(onNext: { [weak self] in
                print("点击添加图片")
                let imagePicker = TZImagePickerController(maxImagesCount: 1, delegate: self)!
                imagePicker.allowPickingVideo = false
                imagePicker.allowTakePicture = true // 允许拍摄
                imagePicker.modalPresentationStyle = .fullScreen
                self?.present(imagePicker, animated: true)
            }).disposed(by: disposeBag)
    }

    private func setupTextInput() {
        let tipLab = UILabel()
        tipLab.text = "PPT 主题/副标题"
        tipLab.textColor = .hex(hexString: "#282828")
        tipLab.font = .boldSystemFont(ofSize: 15)
        view.addSubview(tipLab)  // 关键添加
        
        tipLab.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(self.navView.snp.bottom).offset(30)
        }
        
        // 创建文本视图
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.placeholder = "请输入PPT 大纲"
        // 添加视图和约束
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(14)
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLab.snp.bottom).offset(10)
            make.height.equalTo(120)
        }
        
        
        let titleLab = UILabel()
        titleLab.text = "PPT 副标题"
        titleLab.textColor = .hex(hexString: "#282828")
        titleLab.font = .boldSystemFont(ofSize: 15)
        view.addSubview(titleLab)  // 关键添加
        titleLab.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(textView.snp.bottom).offset(10)
        }
        
        
        // 创建文本视图
        let contentView = UITextView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.font = UIFont.systemFont(ofSize: 16)
        contentView.delegate = self
        contentView.placeholder = "请输入PPT 主题/内容"
        // 添加视图和约束
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(14)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(10)
            make.height.equalTo(120)
        }
        
        let imgLab = UILabel()
        imgLab.text = "主图"
        imgLab.textColor = .hex(hexString: "#282828")
        imgLab.font = .boldSystemFont(ofSize: 15)
        view.addSubview(imgLab)  // 关键添加
        imgLab.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(contentView.snp.bottom).offset(10)
        }
        
        let iconBut = UIButton(type: .custom)
        iconBut.setImage(.addCopy, for: .normal)
        iconBut.layer.cornerRadius = 8
        iconBut.layer.masksToBounds = true
        iconBut.imageView?.contentMode = .scaleAspectFill
        view.addSubview(iconBut)
        iconBut.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(imgLab.snp.bottom).offset(10)
            make.width.height.equalTo(80)
        }
        
        // 保持引用
        self.contentTextF = textView
        self.tipTextF = contentView
        self.imgBut = iconBut
        
        
        let nextBut = UIButton(type: .custom)
        nextBut.setTitle("开始生成", for: .normal)
        nextBut.backgroundColor = .hex(hexString: "0x43bbff")
        
        // 事件订阅保持RxSwift方式
        nextBut.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let content = self.contentTextF.text.trimmingCharacters(in: .whitespacesAndNewlines)
                let tip = self.tipTextF.text.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard !content.isEmpty else {
                    SVProgressHUD.showInfo(withStatus: "请输入PPT大纲")
                    return
                }
                
                guard !tip.isEmpty else {
                    SVProgressHUD.showInfo(withStatus: "请输入PPT主题/内容")
                    return
                }
                
                SVProgressHUD.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                    SVProgressHUD.show(withStatus: "等待生成，稍后再作者中心中展示")
                    self.back()
                }
            })
            .disposed(by: disposeBag)
        nextBut.layer.cornerRadius = 12
        nextBut.layer.masksToBounds = true
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints { make in
            make.top.equalTo(iconBut.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.height.equalTo(44)
        }
    }
}


// MARK: - TZImagePickerControllerDelegate
extension AIPPTViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let image = photos.first else { return }
        imgBut.setImage(image, for: .normal)
    }
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        SVProgressHUD.showInfo(withStatus: "已取消选择")
    }
}


// MARK: - TextView Delegate
extension AIPPTViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 手动触发RxSwift的文本观察
        textView.rx.text.onNext(textView.text)
    }
}
