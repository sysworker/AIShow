//
//  AIHome.swift
//  AiShow
//
//  Created by joyo on 2025/4/16.
//

import UIKit

class AIHome: UIViewController {
    private var aiToolsData: AIToolsData? // 添加数据存储属性
    
    /// 集合视图
    private lazy var toolCollectionView: UICollectionView = {
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        ///行间距
        layout.minimumLineSpacing = 10
        ///列间距
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 8, left: 22, bottom: 16, right: 22)
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: screenW, height: 40) // 增加头部高度

        // 创建集合视图
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collection.register(AIitemHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AIitemHeadView.reuseIdentifier)
        
        collection.register(AIitemCollectionViewCell.self, forCellWithReuseIdentifier: AIitemCollectionViewCell.reuseIdentifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        
        // 添加刷新控件
        let header = MJRefreshNormalHeader { [weak self] in
//            self?.refreshData()
            collection.mj_header?.endRefreshing()
        }
        
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("正在刷新", for: .refreshing)
        collection.mj_header = header
        
        let footer = MJRefreshBackNormalFooter { [weak self] in
//            self?.loadMoreData()
            collection.mj_footer?.endRefreshing()
        }
        footer.setTitle("上拉加载更多", for: .idle)
        footer.setTitle("正在加载", for: .refreshing)
        footer.setTitle("没有更多数据了", for: .noMoreData)
        collection.mj_footer = footer
        
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImgV = UIImageView(image: UIImage(named: "icon_bg_img1"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let homeTitleLab = UILabel()
        homeTitleLab.isHidden = true
        homeTitleLab.text = "主页"
        homeTitleLab.font = .boldSystemFont(ofSize: 30)
        homeTitleLab.textColor = .black
        view.addSubview(homeTitleLab)
        homeTitleLab.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.view.snp.top).offset(tabbarSafeMargin+20)
        }
        
        view.addSubview(toolCollectionView)
        toolCollectionView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(tabbarHeight+10)
            make.top.equalTo(self.view.snp.top).offset(tabbarSafeMargin+20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        
        let model = loadAIToolsData()
        guard let model = model else{
            return
        }
        print("AiModel --- %@",model);
    }
    
    
    func loadAIToolsData() -> AIToolsData? {
        guard let fileURL = Bundle.main.url(forResource: "HomeAIModel", withExtension: "json") else {
            print("无法找到HomeAIModel.json文件")
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder() // 使用JSONDecoder而不是PropertyListDecoder
            let aiToolsData = try decoder.decode(AIToolsData.self, from: data)
            self.aiToolsData = aiToolsData
            toolCollectionView.reloadData() // 加载完成后刷新UI
            return aiToolsData
        } catch {
            print("读取JSON数据错误: \(error)")
            return nil
        }
    }
}

extension AIHome: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: AIitemHeadView.reuseIdentifier,
                                                                             for: indexPath) as! AIitemHeadView

            headerView.configure(row: indexPath.section)
            headerView.backgroundColor = .clear  // 设置透明背景以便于调试
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return section == 0 ? aiToolsData?.hotTools.count : aiToolsData?.latestAdditions.count // 使用实际数据数量
        if section == 0{
            return aiToolsData?.hotTools.count ?? 0 // 使用实际数据数量
        }
        return aiToolsData?.latestAdditions.count ?? 0 // 使用实际数据数量
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AIitemCollectionViewCell.reuseIdentifier, for: indexPath) as? AIitemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            // 配置cell显示数据
            guard let tool = aiToolsData?.hotTools[indexPath.item] else {
                return cell
            }
            cell.configure(model: tool)
        }else{
            guard let tool = aiToolsData?.latestAdditions[indexPath.item] else {
                return cell
            }
            cell.configure(model: tool)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var vc = BaseVC()
        
        if indexPath.section == 0 {
            guard let tool = aiToolsData?.hotTools[indexPath.item] else { return }
            
            switch tool.tag {
            case 1:
                vc = AIPhotoShowViewController()
            case 2:
                let chatVC = ChatViewController()
                chatVC.aiModel = tool  // 直接使用具体类型
                vc = chatVC
            case 3:
                vc = AIPPTViewController()
            case 6:
                vc = AIPhotoController()
            case 7:
                vc = AIPhotoController()
            case 8:
                vc = AIPPTViewController()
            default:
                let chatVC = ChatViewController()
                chatVC.aiModel = tool
                vc = chatVC
            }
        } else {
            guard let tool = aiToolsData?.latestAdditions[indexPath.item] else { return }
            
            let chatVC = ChatViewController()
            chatVC.aiModel = tool
            vc = chatVC
        }
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 获取布局对象
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 150, height: 100) // 默认尺寸
        }
        
        // 计算单元格宽度
        let sectionInset = layout.sectionInset
        let contentWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let minInteritemSpacing = layout.minimumInteritemSpacing
        let numberOfItemsPerRow: CGFloat = 2 // 每行展示2个单元格
        
        // 宽度 = (总宽度 - 所有间距) / 单元格数量
        let width = (contentWidth - minInteritemSpacing * (numberOfItemsPerRow - 1)) / numberOfItemsPerRow
        
        // 比例计算高度 (可以根据需要调整，这里使用1:1的宽高比)
        let height = width * 0.6 // 或者保持固定高度100
        
        return CGSize(width: floor(width), height: floor(height))
    }
}
