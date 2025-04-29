//
//  PlazaViewController.swift
//  AiShow
//
//  Created by joyo on 2025/4/16.
//

import UIKit

// AiBanner模型
struct AIBannerModel: Codable {
    var icon: String
    var name: String
    var h5Url: String
    // 用于解码的CodingKeys
    enum CodingKeys: String, CodingKey {
        case icon, name, h5Url
    }
}


class PlazaViewController: BaseVC {
    private var collectionView: UICollectionView!
    private var timer: Timer?
    private let realItemCount = 6
    private let scrollInterval: TimeInterval = 2.5
    private let virtualItemCount = 1000
    private var selectedIndex: Int = 0
    
    /// 列表数据
    private var dynamicListData: [DynamicModel] = []
    /// 页码，用于分页加载
    private var pageNumber = 1
    /// 是否正在加载数据
    private var isLoading = false
    /// 每页加载的数据量
    private let pageSize = 10
    /// 是否有更多数据
    private var hasMoreData = true
    private var dynamicData: DynamicData? // 添加数据存储属性
    private let disposeBag = DisposeBag()
    
    private lazy var listTableview : UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.backgroundColor = .clear /*.hex(hexString: "#f5f5f5")*/
        tab.register(UserDynamicInfoCell.self, forCellReuseIdentifier: "UserDynamicInfoCell")

        
        // 添加刷新控件
        let header = MJRefreshNormalHeader { [weak self] in
            self?.headerRefresh()
        }
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("正在刷新", for: .refreshing)
        tab.mj_header = header
        
        let footer = MJRefreshBackNormalFooter { [weak self] in
            self?.loadMore()
        }
        footer.setTitle("上拉加载更多", for: .idle)
        footer.setTitle("正在加载", for: .refreshing)
        footer.setTitle("没有更多数据了", for: .noMoreData)
        tab.mj_footer = footer
        return tab
    }()
    
    //https://ai-bot.cn/wp-content/uploads/2023/08/daily-ai-news.png
    private var  bannerArr : [AIBannerModel] = {
        let banner1 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2023/08/daily-ai-news.png", name: "AI快讯", h5Url: "https://ai-bot.cn/daily-ai-news/")
        let banner2 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2023/08/ai-news-aug-ep-01.png", name: "AI快讯：8月第1期（8月1日到8月10日的AI行业新闻）", h5Url: "https://ai-bot.cn/ai-news-august-episode-1/")
        let banner3 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2023/07/ai-news-july-ep-03.png", name: "AI快讯：7月第3期（7月21日到7月31日的AI行业新闻）", h5Url: "https://ai-bot.cn/ai-news-july-episode-3/")
        let banner4 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2023/07/ai-news-july-ep-02.png", name: "AI快讯：7月第2期（7月11日到7月20日的AI行业新闻）", h5Url: "https://ai-bot.cn/ai-news-july-episode-2/")
        let banner5 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2023/07/ai-news-july-01.png", name: "AI快讯：7月第1期（7月1日到7月10日的AI行业新闻）", h5Url: "https://ai-bot.cn/ai-news-july-episode-1/")
        let banner6 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2025/04/Vibe-Coding.png", name: "什么是氛围编程（Vibe Coding） – AI百科知识", h5Url: "https://ai-bot.cn/what-is-vibe-coding/")
        let banner7 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2025/03/MCP.png", name: "什么是MCP（Model Context Protocol） – AI百科知识", h5Url: "https://ai-bot.cn/what-is-mcp/")
        let banner8 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2025/03/Cod-website.png", name: "什么是草稿链（Chain-of-Draft, CoD） – AI百科知识", h5Url: "https://ai-bot.cn/what-is-chain-of-draft-cod/")
        let banner9 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2025/01/NSA-1.png", name: "什么是NSA（Native Sparse Attention） – AI百科知识", h5Url: "https://ai-bot.cn/what-is-native-sparse-attention-nsa/")
        let banner10 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2025/01/Discriminative-Model.png", name: "什么是判别式模型（Discriminative Model） – AI百科知识", h5Url: "https://ai-bot.cn/what-is-discriminative-model/")
        let banner11 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2025/01/Agentic-RAG.png", name: "什么是智能体RAG（Agentic RAG） – AI百科知识", h5Url: "https://ai-bot.cn/what-is-agentic-rag/")
        let banner12 = AIBannerModel(icon: "https://ai-bot.cn/wp-content/uploads/2025/01/Slow-Perception.png", name: "什么是慢感知（slow perception） – AI百科知识", h5Url: "https://ai-bot.cn/what-is-slow-perception/")

        let arr = [banner1,banner2,banner3,banner4,banner5,banner6,banner7,banner8,banner9,banner10,banner11,banner12]
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        super.initUI()
        navView.backgroundColor = .clear
        navView.isHidden = false
        self.navLeftBtn.isHidden = true
        
        let bgImgV = UIImageView(image: UIImage(named: "icon_bg_img2"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6

        let screenWidth = UIScreen.main.bounds.width
        let normalItemWidth = (screenWidth - (CGFloat(2) * layout.minimumLineSpacing)) / 3
        let selectedItemWidth = normalItemWidth * 1.5
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.isUserInteractionEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.isHidden = true
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(screenWidth)
            make.height.equalTo(80)
        }

        let initialIndex = virtualItemCount / 2
        selectedIndex = initialIndex
        collectionView.scrollToItem(at: IndexPath(item: initialIndex, section: 0), at: .left, animated: false)
        collectionView.selectItem(at: IndexPath(item: initialIndex, section: 0), animated: false, scrollPosition: .left)
//        startTimer()
        
        
        
        let pagerView = FSPagerView()
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        ///滚动时间
        pagerView.automaticSlidingInterval = 1.7
        ///间距
        pagerView.interitemSpacing = 10
        ///模式
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        ///是否无限滚动
        pagerView.isInfinite = true
        ///大小
        pagerView.itemSize = CGSize(width: screenWidth/1.5, height: 120)
        self.view.addSubview(pagerView)
        
        pagerView.snp.makeConstraints { make in
            make.top.equalTo(self.navView.snp.bottom).offset(5)
            make.width.equalTo(screenWidth)
            make.height.equalTo(120)
        }
        
        self.listTableview.showsVerticalScrollIndicator = false
         self.view.addSubview(self.listTableview)
         self.listTableview.snp.makeConstraints { make in
             make.leading.trailing.bottom.equalToSuperview()
             make.top.equalTo(pagerView.snp.bottom).offset(10)
         }
         
        
        // 在initUI方法的导航栏部分添加发布按钮
        navRightBtn.setImage(.iconMessage, for: .normal)
        // 发送按钮点击
        navRightBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else{
                    return
                }
                let chatVC = AIMessageController()
                chatVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(chatVC, animated: true)
            }).disposed(by: disposeBag)
        
        
        let publishBtn = UIButton()
        publishBtn.setImage(.iconSendDynamic, for: .normal)
        publishBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            let vc = PublishDynamicViewController()
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
        
        view.addSubview(publishBtn)
        publishBtn.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
            make.width.height.equalTo(64)
        }
        let model = loadDynamicData()
        guard let model = model else{
            return
        }
        loadData()
        print("AiModel --- %@",model);
    }

    func loadDynamicData() -> DynamicData? {
        guard let fileURL = Bundle.main.url(forResource: "Dynamic", withExtension: "json") else {
            print("无法找到HomeAIModel.json文件")
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder() // 使用JSONDecoder而不是PropertyListDecoder
            let modelData = try decoder.decode(DynamicData.self, from: data)
            self.dynamicData = modelData
//            toolCollectionView.reloadData() // 加载完成后刷新UI
            return modelData
        } catch {
            print("读取JSON数据错误: \(error)")
            return nil
        }
    }
    
    
    
    /// 加载数据
    private func loadData() {
        isLoading = true
        
        // 网络请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            guard let dynamicData = self.dynamicData else { // 添加安全解包
                print("动态数据未加载完成")
                self.isLoading = false
                return
            }
            
            // 数据请求
            var newData: [DynamicModel] = []
            
            
            // 每页获取 pageSize 条数据
            for _ in 1...self.pageSize {
                let randomAvatarIndex = Int.random(in: 0..<dynamicData.head.count)
                let randomNameIndex = Int.random(in: 0..<dynamicData.name.count)
                let randomContentIndex = Int.random(in: 0..<dynamicData.content.count)
                
                let dynamicModel = DynamicModel(
                    headImg: dynamicData.head[randomAvatarIndex],
                    nickNameStr: dynamicData.name[randomNameIndex],
                    contentStr: dynamicData.content[randomContentIndex]
                )
                newData.append(dynamicModel)
            }
            // 成功加载 \(newData.count) 条动态数据
            
            // 如果是第一页，就替换现有数据
            if self.pageNumber == 1 {
                self.dynamicListData = newData
            } else {
                // 否则追加数据
                self.dynamicListData.append(contentsOf: newData)
            }
            
            // 判断是否还有更多数据
            self.hasMoreData = self.dynamicListData.count < 80 // 假设最多30条数据
            
            // 刷新集合视图
            self.listTableview.reloadData()
                        
            // 结束刷新
            self.listTableview.mj_header?.endRefreshing()
            
            if self.hasMoreData {
                self.listTableview.mj_footer?.endRefreshing()
            } else {
                self.listTableview.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
    
    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            
            self.pageNumber = 1
            self.dynamicListData.removeAll()
            self.loadData()
            
            
            self.listTableview.mj_header?.endRefreshing()
            self.listTableview.reloadData()
        }
    }
    
    @objc func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            
            guard self.isLoading && self.hasMoreData else {
                self.listTableview.mj_footer?.endRefreshing()
                return
            }
            
            self.pageNumber += 1
            self.loadData()
            
            self.listTableview.reloadData()
            self.listTableview.mj_footer?.endRefreshing()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: scrollInterval, target: self, selector: #selector(scrollCollectionView), userInfo: nil, repeats: true)
    }

    @objc private func scrollCollectionView() {
        guard let collectionView = collectionView else { return }
        var nextIndex = selectedIndex + 1
        if nextIndex >= virtualItemCount {
            nextIndex = virtualItemCount / 2
            collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .left, animated: false)
        }
        // 取消之前选中的单元格
        if let previousIndexPath = collectionView.indexPathsForSelectedItems?.first {
            let previousCell = collectionView.cellForItem(at: previousIndexPath)
            previousCell?.backgroundColor = .gray
            collectionView.deselectItem(at: previousIndexPath, animated: false)
        }
        selectedIndex = nextIndex
        collectionView.selectItem(at: IndexPath(item: nextIndex, section: 0), animated: true, scrollPosition: .left)
        if let currentCell = collectionView.cellForItem(at: IndexPath(item: nextIndex, section: 0)) {
            currentCell.backgroundColor = .red
        }
        // 添加布局刷新确保尺寸更新
        collectionView.layoutIfNeeded()
        // 修改滚动位置为居中
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), 
                                  at: .centeredHorizontally, // 原为 .left
                                  animated: true)
        // 强制刷新布局
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension PlazaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return virtualItemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .gray
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let normalItemWidth = (screenWidth - (CGFloat(2) * 6)) / 3
        let selectedItemWidth = normalItemWidth * 1.5
        return indexPath.item == selectedIndex ? CGSize(width: selectedItemWidth, height: 80) : CGSize(width: normalItemWidth, height: 80)
    }
}

extension PlazaViewController :FSPagerViewDelegate,FSPagerViewDataSource{
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.bannerArr.count
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let model = self.bannerArr[index]
        cell.imageView?.sd_setImage(with: .init(string: model.icon))
        cell.textLabel?.text = model.name
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int){
        let model = self.bannerArr[index]
        print("点击了banner----地址:\(model.h5Url)")
        let urlStr = URL(string: model.h5Url)!
        let vc = AIWebViewController(url:urlStr)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}




extension PlazaViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicListData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserDynamicInfoCell",
            for: indexPath
        ) as? UserDynamicInfoCell else {
            return UITableViewCell()
        }
        
        // 设置举报按钮的回调
        cell.reportActionHandler = { [weak self] in
            self?.showReportOptions(forRow: indexPath.row)
        }
        
        // 配置单元格数据
        if indexPath.row < dynamicListData.count {
            let model = dynamicListData[indexPath.row]
            cell.configure(with: model)
        }
        
        return cell
    }
    
    // 显示举报选项
    private func showReportOptions(forRow row: Int) {
        let alertController = UIAlertController(
            title: "举报内容",
            message: "请选择举报原因",
            preferredStyle: .actionSheet
        )
        
        // 获取要举报的内容信息
        guard row < dynamicListData.count else { return }
        let reportedContent = dynamicListData[row]
        let reportMessage = "举报用户: \(reportedContent.nickNameStr)"
        alertController.message = reportMessage
        
        // 添加举报选项
        let spamAction = UIAlertAction(title: "垃圾邮件或广告", style: .default) { [weak self] _ in
            self?.handleReport(reason: "垃圾邮件或广告", forRow: row)
        }
        
        let harassmentAction = UIAlertAction(title: "骚扰", style: .default) { [weak self] _ in
            self?.handleReport(reason: "骚扰", forRow: row)
        }
        
        let harassment2Action = UIAlertAction(title: "传播不健康内容", style: .default) { [weak self] _ in
            self?.handleReport(reason: "传播不健康内容", forRow: row)
        }
        
        let inappropriateAction = UIAlertAction(title: "不良内容", style: .default) { [weak self] _ in
            self?.handleReport(reason: "不良内容", forRow: row)
        }
        
        let otherAction = UIAlertAction(title: "其它原因", style: .default) { [weak self] _ in
            self?.handleReport(reason: "其它原因", forRow: row)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        // 将选项添加到警告控制器
        alertController.addAction(spamAction)
        alertController.addAction(harassmentAction)
        alertController.addAction(harassment2Action)
        alertController.addAction(inappropriateAction)
        alertController.addAction(otherAction)
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
    
    // 处理举报
    private func handleReport(reason: String, forRow row: Int) {
        // 这里可以添加实际的举报逻辑，比如发送到服务器
        guard row < dynamicListData.count else { return }
        let reportedContent = dynamicListData[row]
        
        // 显示举报成功提示
        let successAlert = UIAlertController(
            title: "举报已提交",
            message: "感谢您的反馈，我们会尽快处理",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            SVProgressHUD.dismiss()
        }
        successAlert.addAction(okAction)
        
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            self.present(successAlert, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 设置每个单元格的高度
    }
}
