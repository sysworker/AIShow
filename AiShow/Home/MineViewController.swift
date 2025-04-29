//
//  MineViewController.swift
//  AiShow
//
//  Created by joyo on 2025/4/16.
//

import UIKit
import YYText
import MessageUI

class MineViewController: BaseVC {

    private let myTitleLab = UILabel()
    private let myHeadImgV = UIImageView()
    private let myNameLab = UILabel()
    private let refreshBut = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        super.initUI()
        navView.backgroundColor = .clear
        //icon_bg_img3
        let bgImgV = UIImageView(image: UIImage(named: "icon_bg_img2"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        myHeadImgV.layer.cornerRadius = 12
        myHeadImgV.layer.masksToBounds = true
        view.addSubview(myHeadImgV)
        myHeadImgV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(navigationBarHeight+80)
            make.width.height.equalTo(130)
        }
     
        refreshBut.setImage(.iconRefresh, for: .normal)
        view.addSubview(refreshBut)
        refreshBut.snp.makeConstraints { make in
            make.bottom.equalTo(self.myHeadImgV.snp.bottom)
            make.right.equalTo(self.myHeadImgV.snp.right)
            make.width.height.equalTo(40)
        }
        refreshBut.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                guard let fileURL = Bundle.main.url(forResource: "Dynamic", withExtension: "json") else {
                    print("无法找到Dynamic.json文件")
                    return
                }
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    let modelData = try decoder.decode(DynamicData.self, from: data)
                    
                    let randomIndex = Int.random(in: 0..<modelData.head.count)
                    let headStr = modelData.head[randomIndex]
                    UserDefaults.standard.set(headStr, forKey: "userHead")
                    self.myHeadImgV.sd_setImage(with: URL(string: headStr), placeholderImage: .iconHeadLogin)
                } catch {
                    print("读取JSON数据错误: \(error)")
                }
                
            }).disposed(by: disBag)
        
        
        myNameLab.font = .systemFont(ofSize: 15)
        myNameLab.textColor = .hex(hexString: "0x282828")
        view.addSubview(myNameLab)
        myNameLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(myHeadImgV.snp.bottom).offset(6)
        }
        let defaultStand = UserDefaults.standard

        self.myNameLab.text = UserDefaults.standard.string(forKey: "userName")
        let headStr = defaultStand.string(forKey: "userHead") ?? ""
        print("\(headStr)")
        
        self.navRightBtn.setImage(.iconMineEdit, for: .normal)
        self.navRightBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.touchChangeName(self.navRightBtn)
            }).disposed(by: disBag)
        
        self.myHeadImgV.sd_setImage(with: URL(string: headStr), placeholderImage: .iconHeadLogin)
        self.navLeftBtn.isHidden = true
        
        myTitleLab.text = "资料"
        myTitleLab.font = .boldSystemFont(ofSize: 20)
        myTitleLab.textColor = .hex(hexString: "0x282828")
        self.view .addSubview(myTitleLab)
        myTitleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.navBarView)
            make.left.equalTo(self.navView.snp.left).offset(26)
        }
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.myNameLab.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        for t in 1...5 {
            let str = t == 1 ? "创作者中心" : t == 2 ? "用户协议" : t == 3 ? "联系我们" : t == 4 ? "注销账号" : "删除账号"
            let bg = myFunction(tag: t, nameStr: str)
            stackView.addArrangedSubview(bg)
            bg.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
        }
    }
    
    func myFunction(tag: Int, nameStr: String) -> UIView {
        let functionBgV = UIView()
        functionBgV.tag = tag
        functionBgV.backgroundColor = .hex(hexString: "0xf7f7f7")
        functionBgV.layer.cornerRadius = 12
        functionBgV.layer.masksToBounds = true
        
        let pushBut = UIButton()
        functionBgV.addSubview(pushBut)
        pushBut.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pushBut.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return}
                self.handleFunctionTap(tag: functionBgV.tag)
            }).disposed(by: disBag)
        

        
        let titleLab = UILabel()
        titleLab.textColor = .black
        titleLab.font = .boldSystemFont(ofSize: 18)
        titleLab.text = nameStr
        functionBgV.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        let arr = UIImageView(image: .iconArrow)
        functionBgV.addSubview(arr)
        arr.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(15)
        }
        return functionBgV
    }

    private func handleFunctionTap(tag: Int) {
        switch tag {
        case 1:
            let vc = AINoDataMessageController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            self.showWebView(url: "https://www.termsfeed.com/live/4f707af2-b457-4328-93bc-a448d856d509")
        case 3:
            sendContactEmail()
        case 4:
            logoutAction()
        case 5:
            showDeleteAccountAlert()
        default:
            break
        }
    }
    
    
    // 新增专用跳转方法
    private func showWebView(url: String) {
        guard let url = URL(string: url) else { return }
        let webVC = AIWebViewController(url: url)
        webVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    
    // MARK: - 发送邮件功能
    private func sendContactEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            // 设置收件人邮箱
            mailComposeVC.setToRecipients(["sysworker@163.com"])
            
            // 设置邮件主题
            mailComposeVC.setSubject("ToolBox用户反馈")
            
            // 设置邮件正文
            let deviceInfo = "设备型号: \(UIDevice.current.model)\n系统版本: \(UIDevice.current.systemVersion)\n应用版本: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "未知")"
            mailComposeVC.setMessageBody("请在此处描述您的问题或建议：\n\n\n\n\n\n\n\n\n----------------------\n用户设备信息：\n\(deviceInfo)", isHTML: false)
            
            // 显示邮件编辑界面
            present(mailComposeVC, animated: true)
        } else {
            // 设备无法发送邮件时的处理
            let alertController = UIAlertController(
                title: "无法发送邮件",
                message: "您的设备未设置邮件账户，请设置邮件账户后再试，或直接发送邮件至sysworker@163.com",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "确定", style: .default)
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
        }
    }
    
    private func showDeleteAccountAlert() {
        let alert = UIAlertController(title: "确认删除", message: "确定要永久删除账号？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "删除", style: .destructive) { [weak self] _ in
            logoutAction()
        })
        present(alert, animated: true)
    }

    func touchChangeName(_ sender: Any) {
        let alertController = UIAlertController(
            title: "请选择操作内容",
            message: "系统昵称不需要审核，上传昵称需要审核",
            preferredStyle: .actionSheet
        )
//        alertController.addTextField()
        
        // 添加举报选项
        let randomAction = UIAlertAction(title: "随机系统昵称", style: .default) { [weak self] _ in
            self?.nickNameReport(reason: "随机系统昵称", forRow: 1)
        }
        
        let cameraAction = UIAlertAction(title: "自定义昵称", style: .default) { [weak self] _ in
            self?.nickNameReport(reason: "自定义昵称", forRow: 2)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        // 将选项添加到控制器
        alertController.addAction(randomAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        // 在iPad上设置弹出位置
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // 显示警告控制器
        present(alertController, animated: true)
    }
    
    
    //修改用户昵称
    private func nickNameReport(reason: String, forRow row: Int) {
        switch row {
        case 1:
            print("系统随机昵称")
            
            guard let fileURL = Bundle.main.url(forResource: "Dynamic", withExtension: "json") else {
                print("无法找到Dynamic.json文件")
                return
            }
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let modelData = try decoder.decode(DynamicData.self, from: data)
                
                let randomIndex = Int.random(in: 0..<modelData.name.count)
                let nameStr = modelData.name[randomIndex]
                self.myNameLab.text = nameStr
            } catch {
                print("读取JSON数据错误: \(error)")
            }
        case 2:
            print("自定义上传昵称")
            let alertController = UIAlertController(
                title: "修改昵称",
                message: "",
                preferredStyle: .alert
            )
            alertController.addTextField()
            
            // 添加举报选项
            let editNameAction = UIAlertAction(title: "确认修改", style: .default) { [weak self] _ in
                SVProgressHUD.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) { [weak self] in
                    guard self != nil else { return }
                    // 显示成功提示
                    SVProgressHUD.showSuccess(withStatus: "等待审核，稍后在消息中心查看")
                }
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            
            // 将选项添加到控制器
            alertController.addAction(editNameAction)
            alertController.addAction(cancelAction)

            // 显示警告控制器
            present(alertController, animated: true)
        default:
            break
        }
    }
}

private func logoutAction() {
    UserDefaults.standard.removeObject(forKey: "userToken")
    UserDefaults.standard.removeObject(forKey: "userName")
    UserDefaults.standard.removeObject(forKey: "userHead")
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.showLogin()
    }
}


// MARK: - MFMailComposeViewControllerDelegate
extension MineViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // 根据发送结果显示不同提示
        switch result {
        case .cancelled:
            print("邮件取消发送")
        case .saved:
            SVProgressHUD.showSuccess(withStatus: "邮件已保存")
        case .sent:
            SVProgressHUD.showSuccess(withStatus: "邮件发送成功")
        case .failed:
            SVProgressHUD.showError(withStatus: "邮件发送失败：\(error?.localizedDescription ?? "未知错误")")
        @unknown default:
            break
        }
        
        // 关闭邮件编辑界面
        controller.dismiss(animated: true)
    }
}
