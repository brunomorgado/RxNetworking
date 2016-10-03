//
//  Operators.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 25/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

public func += (inout left: [String: AnyObject]?, right: [String: AnyObject]?) {
    let _left = left ?? [String: AnyObject]()
    let _right = right ?? [String: AnyObject]()
    left = _left.reduce(_right) { t, e in
        var t = t
        t[e.0] = e.1
        return t
    }
}

public func += (inout left: [String: String]?, right: [String: String]?) {
    let _left = left ?? [String: String]()
    let _right = right ?? [String: String]()
    left = _left.reduce(_right) { t, e in
        var t = t
        t[e.0] = e.1
        return t
    }
}
