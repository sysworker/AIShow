//
//  AIPhotoShowViewController.swift
//  AiShow
//
//  Created by joyo on 2025/4/23.
//

import UIKit

class AIPhotoShowViewController: BaseVC {
    private var  bannerArr : [AIBannerModel] = {
        let banner1 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/77483/cae06f6ecbcc4476841ed5363aea5002.jpg", name: "", h5Url: "")
        let banner2 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/36406/52d43d46bf4a419f80b2e1f3d5b4208b.jpg", name: "", h5Url: "")
        let banner3 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/77483/07ae6f9c82c840d49cbe7a6d34d9bec6.jpg", name: "", h5Url: "")
        let banner4 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/36406/4a3b333c3c124b75b19107be7ab6a854.jpg", name: "", h5Url: "")
        let banner5 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/77483/1f0be4a05ebd47619b417ef0a28f756f.png", name: "", h5Url: "")
        let banner6 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/77483/eb7fd93cffdf44c8b10c8bba9ab26499.jpg", name: "", h5Url: "")
        let banner7 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/90882/a966c26048d54da5bd9112963aa77096.jpg", name: "", h5Url: "")
        let banner8 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/36406/b41a0380eee7475b92e927f600b8b61e.jpg", name: "", h5Url: "")
        let banner9 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/36406/289c20aeece8472797ab9222d5b0fcf8.jpg", name: "", h5Url: "")
        let banner10 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/36406/0828df4cb3e54f4eaf817d1a05703fba.jpg", name: "", h5Url: "")

        let arr = [banner1,banner2,banner3,banner4,banner5,banner6,banner7,banner8,banner9,banner10]
        return arr
    }()
    
    private var festivalBannerArr : [AIBannerModel] = {
        let banner1 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/02154/638d44d7b48c4b5fb9566606e2c2e7bc.jpg", name: "", h5Url: "")
        let banner2 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/02154/b79cf8fdd1144f418155c714e3353d07.jpg", name: "", h5Url: "")
        let banner3 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/02154/638d44d7b48c4b5fb9566606e2c2e7bc.jpg", name: "", h5Url: "")
        let banner4 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/74244/d6c09229348a44ebb0913d6b4efcbf59.png", name: "", h5Url: "")
        let banner5 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/29681/c829551b60604217b11a1de987db1b6b.jpg", name: "", h5Url: "")
        let banner6 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/53357/4f24bf7234eb4ee3b8e8aa0aed676bdc.jpg", name: "", h5Url: "")
        let banner7 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/74244/af312594239146fb85fbc56ad705b940.jpg", name: "", h5Url: "")
        let banner8 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/53357/c251dea061d14c439351146581ff4001.jpg", name: "", h5Url: "")
        let banner9 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/74244/cab887d92ade46ae9073cf1c8a1aedcf.jpg", name: "", h5Url: "")
        let banner10 = AIBannerModel(icon: "https://gd-filems.dancf.com/gaoding/gaoding/74244/c1d8b5ecdf0a41da8b08998b283efc48.jpg", name: "", h5Url: "")

        let arr = [banner1,banner2,banner3,banner4,banner5,banner6,banner7,banner8,banner9,banner10]
        return arr
    }()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initUI() {
        super.initUI()
        
        navTitleLabel.text = "AI 吐司"
        view.backgroundColor = .hex(hexString: "#F8F8F8")
       
        let tipLab = UILabel()
        tipLab.text = "优秀图片展示"
        tipLab.textColor = .hex(hexString: "#989898")
        tipLab.font = .boldSystemFont(ofSize: 15)
        view.addSubview(tipLab)  // 关键添加
        
        tipLab.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(self.navView.snp.bottom).offset(15)
        }
        
        
        let pagerView = FSPagerView()
        pagerView.tag = 10
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        ///滚动时间
        pagerView.automaticSlidingInterval = 1.7
        ///间距
        pagerView.interitemSpacing = 10
        ///模式
        pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
        ///是否无限滚动
        pagerView.isInfinite = true
        ///大小
        pagerView.itemSize = CGSize(width: 150, height: 200)
        self.view.addSubview(pagerView)

        // 修改1：修正安全区域布局（约第79行）
        pagerView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom).offset(20) // 替换statusBarBottomHeight为导航栏底部
            make.leading.equalToSuperview()
            make.width.equalTo(screenW)
            make.height.equalTo(250)
        }
        
        
        
        let titleLab = UILabel()
        titleLab.text = "节日海报"
        titleLab.textColor = .hex(hexString: "#989898")
        titleLab.font = .boldSystemFont(ofSize: 15)
        view.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(pagerView.snp.bottom).offset(15)
        }
        
        let pagerView2 = FSPagerView()
        pagerView2.tag = 20
        pagerView2.dataSource = self
        pagerView2.delegate = self
        pagerView2.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        ///滚动时间
        pagerView2.automaticSlidingInterval = 1.7
        ///间距
        pagerView2.interitemSpacing = 10
        ///模式
        pagerView2.transformer = FSPagerViewTransformer(type: .linear)
        ///是否无限滚动
        pagerView2.isInfinite = true
        ///大小
        pagerView2.itemSize = CGSize(width: 150, height: 200)
        self.view.addSubview(pagerView2)

        pagerView2.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.width.equalTo(screenW)
            make.height.equalTo(200)
        }
        
        
        // 创建文本视图
        let contentView = UITextView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.font = UIFont.systemFont(ofSize: 16)
        contentView.delegate = self
        contentView.placeholder = "请输入要生成的内容/颜色/主题/任务"
        // 添加视图和约束
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(14)
            make.centerX.equalToSuperview()
            make.top.equalTo(pagerView2.snp.bottom).offset(20)
            make.height.equalTo(120)
        }
        
        let nextBut = UIButton(type: .custom)
        nextBut.setTitle("开始生成", for: .normal)
        nextBut.backgroundColor = .hex(hexString: "0x43bbff")
        
        // 事件订阅保持RxSwift方式
        nextBut.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            SVProgressHUD.show(withStatus: "等待生成，稍后在作者中心中展示")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                SVProgressHUD.dismiss()
                self.back()
            }
        }).disposed(by: disposeBag)
        nextBut.layer.cornerRadius = 12
        nextBut.layer.masksToBounds = true
        view.addSubview(nextBut)
        nextBut.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.height.equalTo(44)
        }
    }

}

extension AIPhotoShowViewController :FSPagerViewDelegate,FSPagerViewDataSource{
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return pagerView.tag == 10 ? self.bannerArr.count:self.festivalBannerArr.count
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let model = pagerView.tag == 10 ? self.bannerArr[index]:self.festivalBannerArr[index]
        cell.imageView?.layer.cornerRadius = 12
        cell.imageView?.layer.masksToBounds = true // 添加裁切设置
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.sd_setImage(with: URL(string: model.icon))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let model = pagerView.tag == 10 ? self.bannerArr[index] : self.festivalBannerArr[index]
        let detailVC = AIPhotoDetailViewController()
        detailVC.bannerModel = model
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}


// MARK: - TextView Delegate
extension AIPhotoShowViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 手动触发RxSwift的文本观察
        textView.rx.text.onNext(textView.text)
    }
}
