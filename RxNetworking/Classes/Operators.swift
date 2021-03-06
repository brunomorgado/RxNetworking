//
//  Operators.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 25/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

public func += (left: inout [String: Any]?, right: [String: Any]?) {
    let _left = left ?? [String: Any]()
    let _right = right ?? [String: Any]()
    left = _left.reduce(_right) { t, e in
        var t = t
        t[e.0] = e.1
        return t
    }
}

public func += (left: inout [String: String]?, right: [String: String]?) {
    let _left = left ?? [String: String]()
    let _right = right ?? [String: String]()
    left = _left.reduce(_right) { t, e in
        var t = t
        t[e.0] = e.1
        return t
    }
}
