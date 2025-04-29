//
//  AIMessageController.swift
//  AiShow
//
//  Created by joyo on 2025/4/27.
//

import UIKit

// 新增消息数据模型
struct MessageModel {
    let headImg: String
    let titleStr: String
    let contentStr: String
}

class AIMessageController: BaseVC {
    private var messageList: [MessageModel] = [
        MessageModel(
            headImg: "icon_meessage_type",
            titleStr: "系统消息",
            contentStr: "暂无系统消息"
        ),
        MessageModel(
            headImg: "icon_dynamic",
            titleStr: "创作消息", 
            contentStr: "暂无最新的创作通知"
        )
    ]

    private lazy var messageListTableview : UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.backgroundColor = .clear /*.hex(hexString: "#f5f5f5")*/
        tab.register(UserDynamicInfoCell.self, forCellReuseIdentifier: "UserDynamicInfoCell")

        
        // 添加刷新控件
        let header = MJRefreshNormalHeader { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
                self?.messageListTableview.mj_header?.endRefreshing()
            }
        }
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("正在刷新", for: .refreshing)
        tab.mj_header = header
        
        let footer = MJRefreshBackNormalFooter { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
                self?.messageListTableview.mj_footer?.endRefreshing()
            }
        }
        footer.setTitle("上拉加载更多", for: .idle)
        footer.setTitle("正在加载", for: .refreshing)
        footer.setTitle("没有更多数据了", for: .noMoreData)
//        tab.mj_footer = footer
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func loadMoreMessages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 模拟加载更多数据
            let newMessages = [
                MessageModel(headImg: "icon_notice", titleStr: "更新通知", contentStr: "新增消息分类功能"),
                MessageModel(headImg: "icon_follow", titleStr: "关注提醒", contentStr: "你有3位新粉丝")
            ]
            self.messageList.append(contentsOf: newMessages)
            self.messageListTableview.reloadData()
            self.messageListTableview.mj_footer?.endRefreshing()
        }
    }
    
    override func initUI() {
        super.initUI()
        self.view.addSubview(self.messageListTableview)
        self.messageListTableview.snp.makeConstraints { make in
            make.top.equalTo(self.navView.snp.bottom).offset(5)
            make.left.bottom.right.equalTo(self.view)
        }
        
        // 添加自动行高设置
        messageListTableview.rowHeight = UITableView.automaticDimension
        messageListTableview.estimatedRowHeight = 80
        self.view.backgroundColor = .white
        
        navTitleLabel.text = "系统消息"
    }
}




extension AIMessageController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserDynamicInfoCell",
            for: indexPath
        ) as? UserDynamicInfoCell else {
            return UITableViewCell()
        }
        
        let message = messageList[indexPath.row]
        cell.headImgV.image = UIImage(named: message.headImg)
        cell.headImgV.contentMode = .scaleAspectFill
        cell.nameLab.text = message.titleStr
        cell.contentLab.text = message.contentStr
        cell.reportBut.isHidden = true
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(AINoDataMessageController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 设置每个单元格的高度
    }
}
