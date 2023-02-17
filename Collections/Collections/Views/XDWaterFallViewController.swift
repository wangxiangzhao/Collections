//
//  XDWaterFallViewController.swift
//  Collections
//
//  Created by wangxiangzhao on 2023/2/17.
//

import UIKit

class XDWaterFallViewController: XDBaseCollectionViewController, XDWaterFallFlowLayoutDelegate {
    
    private let _layout = XDWaterFallFlowLayout()
    override var layout: UICollectionViewLayout {
        _layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _layout.columns = _layout.columns == 2 ? 3 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == vm.images.count - 1 {
            loadData()
        }
    }
    
    //MARK: - XDWaterFallFlowLayoutDelegate
    func waterFallFlowLayout(_ waterFallFlowLayout: XDWaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
        let image = vm.images[indexPath.item]
        return _layout.itemWidth / image.size.width * image.size.height
    }
    
    override func loadSubviews() {
        let  margin: CGFloat = 8
        _layout.minimumLineSpacing = 10
        _layout.minimumInteritemSpacing = margin
        _layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        _layout.delegate = self
        super.loadSubviews()
    }
    
}
