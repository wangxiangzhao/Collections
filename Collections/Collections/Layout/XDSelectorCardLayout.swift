//
//  XDSelectorCardLayout.swift
//  SwiftTest
//
//  Created by wangxiangzhao on 2023/2/16.
//

import UIKit

class XDSelectorCardLayout: UICollectionViewLayout {
    //可见的个数
    var visibleCount: Int = 4
    //四周的边距
    var margin: UIEdgeInsets = .zero
    //item之间的间距, y轴方向
    var spacing: CGFloat = 20
    //x轴方向
    var lineSpacing: CGFloat = 10

    // 布局数组
    private lazy var layoutAttributeArray: [UICollectionViewLayoutAttributes] = []
    //最前层的最大y坐标
    private lazy var maxY = CGFloat(visibleCount - 1) * spacing
    //最后面的最大x坐标
    private lazy var maxX = CGFloat(visibleCount - 1) * lineSpacing
    private var itemCount: Int = 0
    
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        layoutAttributeArray = []
        itemCount = collectionView.numberOfItems(inSection: 0)
        let width = collectionView.frame.width - margin.left - margin.right
        let height = collectionView.frame.height - margin.bottom - margin.top - maxY
        let drawCount = visibleCount + 1
        let count = min(itemCount, drawCount)
        let start = max(0, itemCount - drawCount)
        for i in 0..<count {
            let indexPath = IndexPath(item: start + i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let y: CGFloat = max(0, maxY - CGFloat(count - 1 - i ) * spacing)
            let xSpacing: CGFloat = CGFloat(min(visibleCount - 1, abs(i - (count - 1)))) * lineSpacing
            attr.frame = CGRect(x: margin.left + xSpacing, y: margin.top + y, width: width - xSpacing * 2 , height: height)
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
    
    func movedCell(ratio: CGFloat) {
        var tempRatio = abs(ratio)
        if tempRatio > 1 {
            tempRatio = 1
        }
        let drawCount = visibleCount + 1
        let count = min(itemCount, drawCount)
        let start = max(0, itemCount - drawCount)
        for i in 0..<count {
            if i == count - 1 {
                continue
            }
            if i == 0 && count > visibleCount {
                continue
            }
            if let cell = collectionView?.cellForItem(at: IndexPath(item: start + i, section: 0)) {
                let y: CGFloat = max(0, maxY - CGFloat(count - 1 - i ) * spacing) + margin.top + tempRatio * spacing
                let xSpacing: CGFloat = CGFloat(min(visibleCount - 1, abs(i - (count - 1)))) * lineSpacing - tempRatio * lineSpacing
                let x = margin.left + xSpacing
                let width = collectionView!.bounds.width - margin.left - margin.right - xSpacing * 2
                var frame = cell.frame
                frame.origin = CGPoint(x: x, y: y)
                frame.size = CGSize(width: width, height: frame.height)
                cell.frame = frame
            }
        }
    }
}
