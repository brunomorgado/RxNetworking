//
//  BasicAuthenticator.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 20/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import RxSwift
import Alamofire

public final class BasicAuthenticator {
    let username: String
    let password: String
    
    public init(withUsername username: String, password: String) {
        self.username = username
        self.password = password
    }
}

// MARK: Authenticator

extension BasicAuthenticator: Authenticator {
    public func authorizationHeader() -> Observable<[String: String]> {
        return Observable.just([K.Authenticator.kAuthHeaderKey: basicAuthHeaderField()])
    }
}

// MARK: Private

private extension BasicAuthenticator {
    func basicAuthHeaderField() -> String {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        return "Basic \(base64Credentials)"
    }
}
