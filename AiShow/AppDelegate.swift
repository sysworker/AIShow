//
//  AppDelegate.swift
//  AiShow
//
//  Created by joyo on 2025/4/15.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        
        // 检查登录状态
        if UserDefaults.standard.string(forKey: "userToken") == nil {
            showLogin()
        } else {
            showMain()
        }
        
        self.window?.makeKeyAndVisible()
        return true
    }

    // 显示登录界面
    func showLogin() {
        let loginVC = AILoginViewController()
        window?.rootViewController = UINavigationController(rootViewController: loginVC)
    }

    // 显示主界面
    func showMain() {
        let rootAiTabbar = AiTabBarViewController()
        window?.rootViewController = rootAiTabbar
    }
}

