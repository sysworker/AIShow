//
//  AIWebViewController.swift
//  AiShow
//
//  Created by joyo on 2025/4/21.
//

import UIKit
import WebKit
import SDWebImage
import TZImagePickerController
import SVProgressHUD
import MessageUI


// MARK: - 隐私政策视图控制器
class AIWebViewController: BaseVC {
    
    private let webView = WKWebView()
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitleLabel.text = "隐私政策"
        loadWebContent()
    }
    
    private var isObserving = false // 新增观察状态标记
    
    override func initUI() {
        super.initUI()
        // 设置网页视图
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp_bottomMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // 添加进度条
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp_bottomMargin).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        // 监听加载进度
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        isObserving = true // 标记已注册观察者
    }
    
    // 修改 deinit 方法
    deinit {
        if isObserving {
            webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
            isObserving = false
        }
    }
    
    
    private func loadWebContent() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func back() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // 监听进度变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", let progress = change?[.newKey] as? Double {
            if let progressView = view.viewWithTag(101) as? UIProgressView {
                progressView.progress = Float(progress)
                progressView.isHidden = progress >= 1.0
            }
        }
    }
}


