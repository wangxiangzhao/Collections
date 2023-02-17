//
//  XDCircleCollectionLayout.swift
//  SwiftTest
//
//  Created by wangxiangzhao on 2023/2/16.
//

import UIKit


class XDCircleCollectionLayout: UICollectionViewLayout {
    var singleCircleItemCount: Int = 4 {
        didSet {
            layoutAttributeArray.removeAll()
            collectionView?.reloadData()
        }
    }
    var itemSize: CGFloat = 100 {
        didSet {
            layoutAttributeArray.removeAll()
            collectionView?.reloadData()
        }
    }

    // 布局数组
    private lazy var layoutAttributeArray: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let min = min(width, height)
        let circleCenter = CGPoint(x: collectionView.bounds.width / 2.0, y: collectionView.bounds.height / 2.0)
        let radius = (min - itemSize) / 2
        let preRadian = 2 * CGFloat.pi / CGFloat(singleCircleItemCount)
        for i in layoutAttributeArray.count..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attr.size = CGSize(width: itemSize, height: itemSize)
            let line = i / singleCircleItemCount
            let radian = Float(CGFloat(i % singleCircleItemCount) * preRadian + CGFloat(line) * preRadian / 4)
            let x = circleCenter.x + CGFloat(cosf(radian)) * radius
            let y = circleCenter.y + CGFloat(sinf(radian)) * radius
            attr.center = CGPoint(x: x, y: y)
            layoutAttributeArray.append(attr)
        }
    }
    
    //在这个方法中，返回所有项目的布局属性。
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 返回相交的区域
        layoutAttributeArray.filter {
            $0.frame.intersects(rect)
        }
    }
    
    ///返回contentSize
    override var collectionViewContentSize: CGSize {
        collectionView?.bounds.size ?? .zero
    }
}
