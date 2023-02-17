//
//  XDCollectionVM.swift
//  Collections
//
//  Created by wangxiangzhao on 2023/2/17.
//

import UIKit

class XDCollectionVM: NSObject {
    var images: [XDImage] = []
    
    func insertData(_ count: Int, callbackHandler: @escaping ()->Void) {
        DispatchQueue.global().async { [weak self] in
            let images = XDDataCenter.images
            for _ in 0..<count {
                self?.images.append(images[Int.random(in: 0..<images.count)])
            }
            DispatchQueue.main.async {
                callbackHandler()
            }
        }
    }
}
