//
//  XDBaseCollectionViewCell.swift
//  Collections
//
//  Created by wangxiangzhao on 2023/2/17.
//

import UIKit

class XDBaseCollectionViewCell: UICollectionViewCell {
    let coverImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.isUserInteractionEnabled = true
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
