//
//  AIitemCollectionViewCell.swift
//  AiShow
//
//  Created by joyo on 2025/4/17.
//

import UIKit
import SDWebImage


// AITool模型
struct AITool: Codable {
    var icon: String
    let name: String
    let description: String
    let tag: Int
    // 用于解码的CodingKeys
    enum CodingKeys: String, CodingKey {
        case icon, name, description,tag
    }
}

// 整体JSON结构
struct AIToolsData: Codable {
    let hotTools: [AITool]
    let latestAdditions: [AITool]
}



class AIitemHeadView: UICollectionReusableView{
    
    // 重用标识符
    static let reuseIdentifier = "AIitemHeadView_Identifier"

    
    let headItemTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.font = .boldSystemFont(ofSize: 24)
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headItemTitle)
        headItemTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(row:Int){
        self.headItemTitle.text = row == 0 ? "热门工具":"最近添加"
    }
}




///AI的Item
class AIitemCollectionViewCell: UICollectionViewCell {
    
    // 重用标识符
    static let reuseIdentifier = "AIitemCollectionViewCell_Identifier"
    
    let iconImgV : UIImageView = {
        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.secondarySystemBackground
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        return imageView
    }()
    
    let itemTitleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hex(hexString: "0x282828")
        lab.font = .boldSystemFont(ofSize: 16)
        return lab
    }()
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.textAlignment = .left
        
        lab.textColor = UIColor.hex(hexString: "0x282828")
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // 设置圆角和阴影
        contentView.backgroundColor = UIColor.hex(hexString: "0xffffff", alpha: 0.8)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        self.contentView .addSubview(self.iconImgV)
        self.contentView.addSubview(self.itemTitleLab)
        self.contentView.addSubview(self.contentLab)
        
        self.iconImgV.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.leading.equalTo(15)
            make.width.height.equalTo(55)
        }
        
        self.itemTitleLab.snp.makeConstraints { make in
            make.left.equalTo(self.iconImgV.snp.right).offset(4)
            make.top.equalTo(self.iconImgV.snp.top);
            make.height.equalTo(20)
        }
        
        self.contentLab.snp.makeConstraints { make in
            make.left.equalTo(self.iconImgV.snp.right).offset(4)
            make.top.equalTo(self.itemTitleLab.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-6)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func configure(model:AITool){
        self.iconImgV .sd_setImage(with: .init(string: model.icon))
        self.itemTitleLab.text = model.name
        self.contentLab.text = model.description
    }
}
