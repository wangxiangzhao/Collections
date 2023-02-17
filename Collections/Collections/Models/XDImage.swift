//
//  XDImage.swift
//  Collections
//
//  Created by wangxiangzhao on 2023/2/17.
//

import UIKit

struct XDImage {
    let name: String
    let type: String
    let size: CGSize
    
    var path: String {
        Bundle.main.path(forResource: name, ofType: type) ?? ""
    }
}

