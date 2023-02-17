//
//  XDSelectorCardViewController.swift
//  Collections
//
//  Created by wangxiangzhao on 2023/2/17.
//

import UIKit

class XDSelectorCardViewController: XDBaseCollectionViewController, XDSelectorCardViewCellDelegate {
    
    private let _layout: XDSelectorCardLayout = XDSelectorCardLayout()
    
    override var layout: UICollectionViewLayout {
        _layout
    }
    
    override var cellType: AnyClass {
        XDSelectorCardViewCell.self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell: XDSelectorCardViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifiter, for: indexPath) as! XDSelectorCardViewCell
        cell.coverImageView.setThumbnail(URL(fileURLWithPath: vm.images[item].path))
        cell.canMove = vm.images.count - 1 == item
        cell.delegate = self
        return cell
    }
    
    //MARK: - XDSelectorCardViewCellDelegate
    func cell(_ cell: XDSelectorCardViewCell, move offsetRatio: CGFloat, select: XDCardSelect) {
        _layout.movedCell(ratio: offsetRatio)
    }
    
    func cell(_ cell: XDSelectorCardViewCell, endMove offsetRatio: CGFloat, select: XDCardSelect) {
        if select == .none {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveLinear]) {
                self._layout.movedCell(ratio: 0)
            }
        }
    }
    
    func cell(_ cell: XDSelectorCardViewCell, remove select: XDCardSelect) {
        vm.images.removeLast()
        if let snapshotView = view.snapshotView(afterScreenUpdates: false) {
            view.addSubview(snapshotView)
            CATransaction.setDisableActions(true)
            collectionView.reloadData()
            CATransaction.commit()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                snapshotView.removeFromSuperview()
            }
        } else {
            collectionView.reloadData()
        }
    }
    
    override func loadSubviews() {
        _layout.margin = UIEdgeInsets(top: 88, left: 25, bottom: 44, right: 25)
        super.loadSubviews()
    }
}
