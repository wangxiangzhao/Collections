//
//  XDSelectorCardViewCell.swift
//  Collections
//
//  Created by wangxiangzhao on 2023/2/17.
//

import UIKit

enum XDCardSelect {
    case none, left, right
}

protocol XDSelectorCardViewCellDelegate: AnyObject {
    //cell移动距离,和选择状态
    func cell(_ cell: XDSelectorCardViewCell, move offsetRatio: CGFloat, select: XDCardSelect)
    //停止移动的状态
    func cell(_ cell: XDSelectorCardViewCell, endMove offsetRatio: CGFloat, select: XDCardSelect)
    //移除cell
    func cell(_ cell: XDSelectorCardViewCell, remove select: XDCardSelect)
}

class XDSelectorCardViewCell: XDBaseCollectionViewCell {
    //拖动时最大可旋转的度数
    var maxRoateDegress: CGFloat = 5 * CGFloat.pi / 180
    //可出发选择事件的最小移动距离
    var minOffset: CGFloat = 150
    var canMove: Bool = false
    
    weak var delegate: XDSelectorCardViewCellDelegate?
    
    private lazy var preRadian =  maxRoateDegress / minOffset
    //x轴方向的阻尼默认是1
    private var xDamp: CGFloat = 1
    private var roatedAngle: CGFloat = 0
    private var initFrame: CGRect = .zero
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initFrame = frame
        
        contentView.layer.cornerRadius = 20
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func drag(_ sender: UIPanGestureRecognizer) {
        guard canMove else {
            return
        }
        guard let view = sender.view else {
            return
        }
        let point = sender.translation(in: view)
        let state = sender.state
        let yDamp: CGFloat = 0.3
        let offset = view.frame.minX - initFrame.minX
        let absOffset = abs(offset)
        var select: XDCardSelect = .none
        if absOffset >= 0 && absOffset <= minOffset {
            select = .none
            xDamp = 1 - 0.6 * absOffset / minOffset
        } else {
            select = offset > 0 ? .right : .left
            xDamp = 0.4
        }
        
        let roate = preRadian * xDamp * point.x
        if roate + roatedAngle > maxRoateDegress {
            roatedAngle = maxRoateDegress
        } else if roate + roatedAngle < -maxRoateDegress {
            roatedAngle = -maxRoateDegress
        } else {
            roatedAngle += roate
        }
        view.transform = view.transform.translatedBy(x: point.x * xDamp, y: point.y * yDamp)
        if abs(roatedAngle) != maxRoateDegress {
            view.transform = view.transform.concatenating(CGAffineTransform(rotationAngle: roate))
        }
        sender.setTranslation(.zero, in: view)
        if state == .changed || state == .began {
            delegate?.cell(self, move: offset / self.minOffset, select: select)
        } else if state == .cancelled || state == .ended || state == .failed {
            xDamp = 1
            roatedAngle = 0
            let screenWidth = UIScreen.main.bounds.width
            delegate?.cell(self, endMove: offset / self.minOffset, select: select)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveLinear]) {
                if select == .none {
                    view.transform = .identity
                } else if select == .left {
                    view.transform = view.transform.translatedBy(x: -screenWidth, y: 0)
                } else {
                    view.transform = view.transform.translatedBy(x: screenWidth, y: 0)
                }
            } completion: { isFinished in
                if select != .none {
                    view.transform = .identity
                    self.delegate?.cell(self, remove: select)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
