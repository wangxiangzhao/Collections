//
//  UIImageView+Exts.swift
//  SwiftTest
//
//  Created by wangxiangzhao on 2023/2/16.
//

import UIKit

extension UIImageView {
    
    //设置缩略图
    func setThumbnail(_ url: URL, to size: CGSize = .zero, scale: CGFloat = 0) {
        let tempSize = size.equalTo(.zero) ? frame.size : size
        DispatchQueue.global().async { [weak self] in
            let thumbnailImage = UIImage.decode(at: url, to: tempSize, isCache: false)
            DispatchQueue.main.async { [weak self] in
                self?.image = thumbnailImage
            }
        }
    }
    
}

