//
//  UserDynamicInfoCell.swift
//  AiShow
//
//  Created by joyo on 2025/4/24.
//

import UIKit


struct DynamicModel {
    var headImg: String
    var nickNameStr: String
    var contentStr: String
      
    init(headImg: String, nickNameStr: String, contentStr: String) {
        self.headImg = headImg
        self.nickNameStr = nickNameStr
        self.contentStr = contentStr
    }
}
// 动态整体JSON结构
struct DynamicData: Codable {
   let head: [String]      // 直接解码字符串数组
   let name: [String]      // 直接解码字符串数组
   let content: [String]   // 直接解码字符串数组
}


class UserDynamicInfoCell: UITableViewCell {

    let bgView = UIView()
    ///头像
    let headImgV = UIImageView()
    ///昵称
    let nameLab = UILabel()
    ///内容
    let contentLab = UILabel()
    ///举报
    let reportBut = UIButton()
    /// 举报回调闭包
    var reportActionHandler: (() -> Void)?
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.bgView.layer.cornerRadius = 11
        self.bgView.backgroundColor = .white
        
        self.headImgV.contentMode = .scaleAspectFill
        self.headImgV.layer.cornerRadius = 10
        self.headImgV.layer.masksToBounds = true
        
        self.nameLab.textColor = .hex(hexString: "0x282828")
        self.nameLab.font = .boldSystemFont(ofSize: 16)
        
        self.contentLab.numberOfLines = 0
        self.contentLab.font = .systemFont(ofSize: 14)
        self.contentLab.textColor = .hex(hexString: "0x282828", alpha: 0.7)
        
        self.reportBut.backgroundColor = .hex(hexString: "0x989898")
        self.reportBut .setTitle("举报", for: .normal)
        self.reportBut.setTitleColor(.white, for: .normal)
        self.reportBut.titleLabel?.font = .systemFont(ofSize: 13)
        self.reportBut.rx.tap
            .subscribe(onNext: { [weak self] in
                // 添加安全解包
                guard let self = self else { return }
                self.reportActionHandler?()
            })
            .disposed(by: disposeBag)
        [self.bgView,self.headImgV,self.nameLab,self.contentLab,self.reportBut].forEach { b in
            contentView.addSubview(b)
        }
        
        self.bgView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalToSuperview().offset(10)
            make.centerX.bottom.equalTo(self.contentView)
        }
        
        self.headImgV.snp.makeConstraints { make in
            make.top.leading.equalTo(self.bgView).offset(5)
        }
        
        self.nameLab.snp.makeConstraints { make in
            make.top.equalTo(self.bgView).offset(10)
            make.left.equalTo(self.headImgV.snp.right).offset(5)
            make.height.equalTo(18)
        }
        
        self.reportBut.layer.masksToBounds = true
        self.reportBut.layer.cornerRadius = 11
        self.reportBut.snp.makeConstraints { make in
            make.top.equalTo(self.bgView.snp.top).offset(5)
            make.right.equalTo(self.bgView.snp.right).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(26)
        }
        
        self.contentLab.snp.makeConstraints { make in
            make.top.equalTo(self.nameLab.snp.bottom).offset(5)
            make.left.equalTo(self.nameLab.snp.left)
            make.right.lessThanOrEqualTo(self.bgView.snp.right).offset(-14)
            make.bottom.equalTo(self.bgView.snp.bottom).offset(-14)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    func configure(with message: DynamicModel) {
        
        self.headImgV .sd_setImage(with: .init(string: message.headImg))
        self.nameLab.text = message.nickNameStr
        self.contentLab.text = message.contentStr
        
        self.headImgV.snp.remakeConstraints { make in
            make.top.leading.equalTo(self.bgView).offset(5)
            make.width.height.equalTo(50)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
