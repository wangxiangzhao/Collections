//
//  XDCircleCollectionViewController.swift
//  Collections
//
//  Created by wangxiangzhao on 2023/2/17.
//

import UIKit

class XDCircleCollectionViewController: XDBaseCollectionViewController {
    
    override var layout: UICollectionViewLayout {
        XDCircleCollectionLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
