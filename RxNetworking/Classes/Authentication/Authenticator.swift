//
//  Authenticator.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 14/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Foundation
import RxSwift

extension K {
    struct  Authenticator {
        static let kAuthHeaderKey = "Authorization"
    }
}

public enum AuthenticatorError: ErrorType {
    case Unknown
}

public protocol Authenticator {
    func authHeaderField() -> Observable<String>
}
