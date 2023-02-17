//
//  XDFloatingWindow.swift
//  SwiftTest
//
//  Created by wangxiangzhao on 2023/2/16.
//

import UIKit

class XDFloatingWindow: UIWindow {
    
    var maxMargins: UIEdgeInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    
    private let screenBounds = UIScreen.main.bounds
    private lazy var screenWidth = screenBounds.width
    private lazy var screenHeight = screenBounds.height

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setUp()
    }
    
    //MARK: - 拖动
    @objc private func drag(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: sender.view)
        let state = sender.state
        if state == .changed || state == .began {
            transform = transform.translatedBy(x: point.x, y: point.y)
        } else if state == .cancelled || state == .ended || state == .failed {
            var x: CGFloat = maxMargins.left, y = frame.minY
            if frame.minX + frame.width / 2 > screenWidth / 2 {
                x = screenWidth - frame.width - maxMargins.right
            }
            if frame.maxY > screenHeight - maxMargins.bottom {
                y = screenHeight - frame.height - maxMargins.bottom
            } else if y < maxMargins.top {
                y = maxMargins.top
            }
            UIView.animate(withDuration: 0.25) {
                self.frame = CGRect(origin: CGPoint(x: x, y: y), size: self.frame.size)
            }
        }
        sender.setTranslation(.zero, in: sender.view)
    }
    
    private func setUp() {
        windowLevel = .alert
        rootViewController = UIViewController()
        makeKeyAndVisible()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
