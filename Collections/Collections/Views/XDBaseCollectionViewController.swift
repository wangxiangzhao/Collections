//
//  XDBaseCollectionViewController.swift
//  Collections
//
//  Created by wangxiangzhao on 2023/2/17.
//

import UIKit
import SnapKit

class XDBaseCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var layout: UICollectionViewLayout {
        UICollectionViewLayout()
    }
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    let vm = XDCollectionVM()
    
    let cellReuseIdentifiter: String = "cellID"
    
    var cellType: AnyClass {
        XDBaseCollectionViewCell.self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubviews()
        loadData()
    }
    
    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XDBaseCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifiter, for: indexPath) as! XDBaseCollectionViewCell
        cell.coverImageView.setThumbnail(URL(fileURLWithPath: vm.images[indexPath.item].path))
        return cell
    }
    
    func loadSubviews() {
        
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(cellType, forCellWithReuseIdentifier: cellReuseIdentifiter)
    }
    
    func loadData() {
        vm.insertData(20) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
