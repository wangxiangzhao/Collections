//
//  XDFPSLabel.swift
//  SwiftTest
//
//  Created by wangxiangzhao on 2023/2/16.
//

import UIKit

class XDFPSLabel: UILabel {

    private lazy var link: CADisplayLink = CADisplayLink(target: XDWeakProxy(target: self), selector: #selector(time(_:)))
    private var lastTime: TimeInterval = 0
    private var count: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        isUserInteractionEnabled = false
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        textColor = .white
        link.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc func time(_ link: CADisplayLink) {
        guard lastTime > 0 else {
            lastTime = link.timestamp
            return
        }
        count += 1
        let delta = link.timestamp - lastTime
        guard delta >= 1 else {
            return
        }
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0
        text = "\(Int(fps.rounded())) FPS"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        link.invalidate()
    }
}
