//
//  AiTabBarViewController.swift
//  AiShow
//
//  Created by joyo on 2025/4/16.
//

import UIKit
import RxSwift
import RxCocoa

class AiTabBarViewController: UITabBarController {

    // 用于管理RxSwift订阅的DisposeBag
    private let disposeBag = DisposeBag()
    
    // MARK: - 重写点击tab的代理方法
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 获取点击的索引
        if let index = tabBar.items?.firstIndex(of: item) {
            print("点击了标签: \(index)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - 设置 TabBar 样式
    private func setupTabBarAppearance() {

        let appearance = UITabBarAppearance()
        // 配置高斯模糊效果
        appearance.configureWithDefaultBackground()
        // 设置模糊效果
        let blurEffect = UIBlurEffect(style: .regular)
        appearance.backgroundEffect = blurEffect
        // 设置轻微的背景色，使模糊效果更加明显
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        // 添加细微的分割线
        appearance.shadowColor = UIColor.lightGray.withAlphaComponent(0.3)
        // 设置选中和未选中的文本颜色
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.hex(hexString: "#989898")
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.hex(hexString: "#D76D77")
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
//        // 设置 TabBar 背景颜色
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .white
//        
//        // 设置选中和未选中的文本颜色
//        let normalAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.hex(hexString: "#dbdbdb")
//        ]
//        let selectedAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.hex(hexString: "#2c2c2c")
//        ]
//        
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
//        
//        tabBar.standardAppearance = appearance
//        tabBar.scrollEdgeAppearance = appearance

        
        let homeVC = UINavigationController(rootViewController: AIHome())
        let homeVC2 = UINavigationController(rootViewController: PlazaViewController())
        let homeVC3 = UINavigationController(rootViewController: MineViewController())
        homeVC.view.backgroundColor = UIColor.white
        homeVC2.view.backgroundColor = UIColor.white
        homeVC3.view.backgroundColor = UIColor.white
        // 设置标题和图标
        homeVC.tabBarItem = UITabBarItem(
            title: "工具",
            image: UIImage(named: "home_normal")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "home_select")?.withRenderingMode(.alwaysOriginal)
        )
        
        homeVC2.tabBarItem = UITabBarItem(
            title: "交流",
            image: UIImage(named: "home_plaza")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "home_plaza_select")?.withRenderingMode(.alwaysOriginal)
        )
        
        homeVC3.tabBarItem = UITabBarItem(
            title: "我的",
            image: UIImage(named: "home_mine")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "home_mine_select")?.withRenderingMode(.alwaysOriginal)
        )
        
        
        let tabbarImg = UIImageView(image: .init(named: "tabbar_bg"))
        tabbarImg.frame = CGRect(x: 0, y: 0, width: screenW, height: tabbarHeight)
        tabBar.insertSubview(tabbarImg, at: 0)
        viewControllers = [homeVC,homeVC2,homeVC3]
    }
}
