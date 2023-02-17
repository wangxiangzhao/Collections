//
//  XDWeakProxy.swift
//  SwiftTest
//
//  Created by wangxiangzhao on 2023/2/16.
//

import UIKit

class XDWeakProxy: NSObject {
    
    private weak var target: NSObject!
    
    class func proxy(_ target: NSObject) -> XDWeakProxy {
        XDWeakProxy(target: target)
    }
    
    convenience init(target: NSObject) {
        self.init()
        self.target = target
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        target
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        target.responds(to: aSelector)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        target.isEqual(object)
    }

    override var hash: Int {
        target.hash
    }
    
    override var superclass: AnyClass? {
        target.superclass
    }
    
    override func `self`() -> Self {
        target.self as! Self
    }
    
    override func isKind(of aClass: AnyClass) -> Bool {
        target.isKind(of: aClass)
    }
    
    override func isMember(of aClass: AnyClass) -> Bool {
        target.isMember(of: aClass)
    }
    
    override func conforms(to aProtocol: Protocol) -> Bool {
        target.conforms(to: aProtocol)
    }
    
    override func isProxy() -> Bool {
        true
    }
    
    override var description: String {
        target.description
    }
    
    override var debugDescription: String {
        target.debugDescription
    }
}
