//
//  AINoDataMessageController.swift
//  AiShow
//
//  Created by joyo on 2025/4/27.
//

import UIKit

class AINoDataMessageController: BaseVC {
    /// 无数据视图
    private lazy var emptyView: UIView = {
        let view = UIView()
//        view.isHidden = true
        
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
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initUI() {
        super.initUI()
        view.backgroundColor = .hex(hexString: "0xF8F8F8")
        
        self.navTitleLabel.text = "消息"
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
