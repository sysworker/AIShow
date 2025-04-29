//
//  AIPhotoShowCell.swift
//  AiShow
//
//  Created by joyo on 2025/4/23.
//

import UIKit

class AIPhotoShowCell: UICollectionViewCell {
    private let bannerImgV: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bannerImgV)
        bannerImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
