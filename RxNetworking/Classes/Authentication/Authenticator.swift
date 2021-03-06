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

public enum AuthenticatorError: Error {
    case unknown
}

public protocol Authenticator {
    func authorizationHeader() -> Observable<[String: String]>
}
