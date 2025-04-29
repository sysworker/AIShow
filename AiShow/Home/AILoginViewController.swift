import UIKit
import YYText
import SnapKit
import RxSwift
import RxCocoa
import SVProgressHUD

class AILoginViewController: BaseVC {
    
    private let bgImageView = UIImageView()
    private let accountField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupGesture()
        setupRxBindings()
    }
    
    override func initUI() {
        super.initUI()
        
        // 导航栏
        navTitleLabel.text = "登录"
        navTitleLabel.font = .systemFont(ofSize: 24)
        navTitleLabel.textColor = .white
        navView.backgroundColor = .clear
        navLeftBtn.setImage(.init(named: "icon_back_arr"), for: .normal)
        navLeftBtn.isHidden = true
        
        // 背景图片
        bgImageView.image = UIImage(named: "icon_login_bg")
        view.insertSubview(bgImageView, at: 0)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 输入框容器
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        
        let icon = UIImageView(image: .init(named: "icon_head_login"))
        icon.layer.cornerRadius = 10
        icon.layer.masksToBounds = true
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).offset(-20)
            make.width.height.equalTo(120)
        }
        
        // 账号输入框
        setupTextField(accountField, placeholder: "账号")
        stackView.addArrangedSubview(accountField)
        accountField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        // 密码输入框
        setupTextField(passwordField, placeholder: "密码")
        passwordField.isSecureTextEntry = true
        stackView.addArrangedSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        // 登录按钮
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitle("登录/注册", for: .normal)
        loginButton.layer.cornerRadius = 22
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(44)
        }
        
        // 调整下方提示标签的位置
        let tipLab = UILabel()
        tipLab.text = "未注册用户自动注册并登录"
        tipLab.textColor = .white
        tipLab.font = .systemFont(ofSize: 12)
        view.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        
        // 修改1：修正协议文本内容
        let textContent = "我已阅读并同意《用户隐私政策》" // 增加隐私政策条款
        
        // 修改2：补充隐私条款高亮处理
        guard let range1 = textContent.range(of: "《用户隐私政策》") else { return }
        
        let nsRange1 = textContent.nsRange(from: range1)
        // 修改3：移除高度限制约束
        let userAgreementLab = YYLabel()
        userAgreementLab.isUserInteractionEnabled = true
        userAgreementLab.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 40  // 增加换行支持
        view.addSubview(userAgreementLab)
        view.bringSubviewToFront(userAgreementLab)
        
        let text = NSMutableAttributedString(string: textContent)
        text.yy_font = .systemFont(ofSize: 14)
        text.yy_color = .white

        // 添加两个高亮范围
        text.yy_setTextHighlight(nsRange1, color: .red, backgroundColor: .clear) { [weak self] _, _, _, _ in
            print("99999")
            self?.showWebView(url: "https://www.termsfeed.com/live/4f707af2-b457-4328-93bc-a448d856d509")
        }
        
        userAgreementLab.attributedText = text
        // 布局约束调整
        userAgreementLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-26)
        }
        
        
    }
    
    // 新增专用跳转方法
    private func showWebView(url: String) {
        guard let url = URL(string: url) else { return }
        let webVC = AIWebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func setupTextField(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.keyboardType = .numberPad // 设置数字键盘
        
        // 添加内边距
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 20))
        field.leftView = paddingView
        field.leftViewMode = .always
    }
    
    private func setupRxBindings() {
        // 输入长度限制（保持不变）
        accountField.rx.text
            .map { String(($0 ?? "").prefix(8)) }
            .bind(to: accountField.rx.text)
            .disposed(by: disposeBag)
            
        passwordField.rx.text
            .map { String(($0 ?? "").prefix(6)) }
            .bind(to: passwordField.rx.text)
            .disposed(by: disposeBag)
        
        // 按钮状态绑定（优化为单一信号源）
        let credentialValid = Observable.combineLatest(
            accountField.rx.text.orEmpty.map { $0.isNumber && $0.count == 8 },
            passwordField.rx.text.orEmpty.map { $0.isNumber && $0.count == 6 }
        ).map { $0 && $1 }
        
        // 按钮启用状态
        credentialValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 按钮颜色样式（保留原有逻辑）
        loginButton.rx.observe(\.isEnabled)
            .subscribe(onNext: { [weak self] enabled in
                self?.loginButton.backgroundColor = enabled ? .systemBlue : .gray
            })
            .disposed(by: disposeBag)
        
        // 登录逻辑（Rx化处理）
        loginButton.rx.tap
            .withLatestFrom(Observable.combineLatest(
                accountField.rx.text.orEmpty,
                passwordField.rx.text.orEmpty
            ))
            .do(onNext: { [weak self] _ in
                self?.view.endEditing(true)
                SVProgressHUD.show()
            })
            .flatMapLatest { [weak self] (account, password) -> Observable<Bool> in
                guard let self = self else { return .empty() }
                return self.loginRequest(account: account, password: password)
            }
            .subscribe(onNext: { [weak self] success in
                success ? self?.handleLoginSuccess() : self?.handleError()
            }, onError: { [weak self] error in
                self?.handleError(error)
            })
            .disposed(by: disposeBag)
    }
    
    // 新增网络请求方法
    private func loginRequest(account: String, password: String) -> Observable<Bool> {
        return Observable.create { observer in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                if account == "10001234" && password == "888888" {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    let error = account == "10001234" ?
                    NSError(domain: "PasswordError", code: 401) :
                    NSError(domain: "AccountError", code: 404)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    // 统一成功处理
    private func handleLoginSuccess() {
        SVProgressHUD.dismiss()
        UserDefaults.standard.set("mock_token_123", forKey: "userToken")
        UserDefaults.standard.set("复苏公子", forKey: "userName")
        UserDefaults.standard.set("https://c-ssl.dtstatic.com/uploads/blog/202501/14/lGSVZJVPuxdDL8O.thumb.400_0.jpg_webp", forKey: "userHead")

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showMain()
        }
    }
    
    // 统一错误处理
    private func handleError(_ error: Error? = nil) {
        SVProgressHUD.dismiss()
        
        if let nsError = error as? NSError {
            switch nsError.code {
            case 401:
                SVProgressHUD.showError(withStatus: "密码错误")
            case 404:
                SVProgressHUD.showError(withStatus: "账号不存在")
            default:
                SVProgressHUD.showError(withStatus: "登录失败")
            }
        } else {
            SVProgressHUD.showError(withStatus: "账号或密码错误")
        }
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func loginAction() {
        view.endEditing(true)
        SVProgressHUD.show()
        // 这里添加登录逻辑
        print("账号：\(accountField.text ?? "")")
        print("密码：\(passwordField.text ?? "")")
        
        
        // 延迟返回前一页
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            if self.accountField.text == "10001234"{
                if self.passwordField.text == "888888"{
                    // 模拟登录成功
                    let mockToken = "mock_token_123"
                    UserDefaults.standard.set(mockToken, forKey: "userToken")
                    
                    // 切换根控制器
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        SVProgressHUD.dismiss()
                        appDelegate.showMain()
                    }
                }else{
                    SVProgressHUD.showError(withStatus: "密码错误")
                }
            }else{
                SVProgressHUD.showError(withStatus:"账号不存在")
            }
        }
    }
}

// Add this below the existing String extension
extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(
            range,
            in: self
        )
    }
}

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
