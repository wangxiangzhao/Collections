//
//  XDWaterFallFlowLayout.swift
//  SwiftTest
//
//  Created by wangxiangzhao on 2023/2/15.
//

import UIKit

protocol XDWaterFallFlowLayoutDelegate: AnyObject {
    //每个item的高度
    func waterFallFlowLayout(_ waterFallFlowLayout: XDWaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat
}

class XDWaterFallFlowLayout: UICollectionViewFlowLayout {
    
    init(columns: Int = 2) {
        super.init()
        self.columns = columns
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 列数
    var columns: Int = 2 {
        didSet {
            layoutAttributeArray.removeAll()
            columnHeightArray = [CGFloat](repeating: self.sectionInset.top, count: columns)
            maxHeight = 0
            collectionView?.reloadData()
        }
    }
    // 布局数组
    private lazy var layoutAttributeArray: [UICollectionViewLayoutAttributes] = []
    // 列高度数组
    private lazy var columnHeightArray: [CGFloat] = [CGFloat](repeating: self.sectionInset.top, count: columns)
    // 最大高度
    private var maxHeight: CGFloat = 0
    weak var delegate: XDWaterFallFlowLayoutDelegate?
    
    var itemWidth: CGFloat {
        guard let rect = collectionView?.bounds, columns > 0 else { return 0 }
        return (CGRectGetWidth(rect) - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }
    
    ///每当布局操作即将发生时，UIKit就会调用这个方法。这是你准备和执行任何计算的机会，以确定集合视图的大小和项目的位置。
    override func prepare() {
        super.prepare()
        // 计算每个 Cell 的宽度
        let itemWidth = itemWidth
        // Cell 数量
        guard let itemCount = collectionView?.numberOfItems(inSection: 0), columns > 0 else {
            return
        }
        // 最小高度索引, 默认第一列最小
        var minHeightIndex = 0
        // 遍历 item 计算并缓存属性
        for i in layoutAttributeArray.count ..< itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // 获取动态高度
            let itemHeight = delegate?.waterFallFlowLayout(self, itemHeight: indexPath)
            // 找到高度最短的那一列
            let value = columnHeightArray.min() ?? 0
            // 获取数组索引
            minHeightIndex = columnHeightArray.firstIndex(of: value) ?? 0
            // 获取该列的 Y 坐标
            var itemY = columnHeightArray[minHeightIndex]
            // 判断是否是第一行，如果换行需要加上行间距
            if i >= columns {
                itemY += minimumLineSpacing
            }
            // 计算该索引的 X 坐标
            let itemX = sectionInset.left + (itemWidth + minimumInteritemSpacing) * CGFloat(minHeightIndex)
            // 赋值新的位置信息
            attr.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: CGFloat(itemHeight!))
            // 缓存布局属性
            layoutAttributeArray.append(attr)
            // 更新最短高度列的数据
            columnHeightArray[minHeightIndex] = attr.frame.maxY
        }
        maxHeight = columnHeightArray.max()! + sectionInset.bottom
    }
    
    ///在这个方法中，返回所有项目的布局属性。
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 返回相交的区域
        layoutAttributeArray.filter {
            $0.frame.intersects(rect)
        }
    }
    
    ///返回contentSize
    override var collectionViewContentSize: CGSize {
        CGSize(width: collectionView?.bounds.width ?? 0, height: maxHeight)
    }
}


///方法的调用顺序
///override func prepare()
///override var collectionViewContentSize: CGSize
///override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
