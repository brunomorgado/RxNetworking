//
//  OAuth2Credential.swift
//  Temp
//
//  Created by Bruno Morgado on 13/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Foundation

extension K {
    struct  OAuth2Credential {
        static let kUsernameKey = "username"
        static let kPasswordKey = "password"
        static let kAccessTokenKey = "access_token"
        static let kTokenTypeKey = "token_type"
        static let kGrantTypeKey = "grant_type"
        static let kRefreshTokenKey = "refresh_token"
        static let kExpirationKey = "expires_in"
    }
}

final class OAuth2Credential: NSObject, NSCoding, Credential {
    let accessToken: String
    let tokenType: String
    var refreshToken: String?
    var expiration: NSDate
    var isExpired: Bool {
        get {
            return expiration.compare(NSDate()) == NSComparisonResult.OrderedAscending
        }
    }
    var readableDescription: String {
        get {
            return "OAuth2Credential - accessToken:\(accessToken) tokenType\(tokenType) refreshToken\(refreshToken) expiration\(expiration)"
        }
    }
    
    init(withAccessToken accessToken: String, tokenType: String, refreshToken: String? = nil, expiration: NSDate = NSDate.distantFuture()) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.expiration = expiration
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard
            let accessToken = decoder.decodeObjectForKey(K.OAuth2Credential.kAccessTokenKey) as? String,
            let tokenType = decoder.decodeObjectForKey(K.OAuth2Credential.kTokenTypeKey) as? String
            else { return nil }
        
        let refreshToken = decoder.decodeObjectForKey(K.OAuth2Credential.kRefreshTokenKey) as? String
        let expiration = decoder.decodeObjectForKey(K.OAuth2Credential.kExpirationKey) as? NSDate
        
        self.init(withAccessToken: accessToken, tokenType: tokenType, refreshToken: refreshToken, expiration: expiration ?? NSDate.distantFuture())
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(accessToken, forKey: K.OAuth2Credential.kAccessTokenKey)
        coder.encodeObject(tokenType, forKey: K.OAuth2Credential.kTokenTypeKey)
        coder.encodeObject(refreshToken, forKey: K.OAuth2Credential.kRefreshTokenKey)
        coder.encodeObject(expiration, forKey: K.OAuth2Credential.kExpirationKey)
    }
}

// MARK: JSONAbleType

extension OAuth2Credential: JSONParsableType {
    
    static func fromJSON(json: AnyObject?) throws -> OAuth2Credential {
        guard let _json = json as? [String: AnyObject] else { throw JSONParsingError.InvalidJSON }
        
        guard let accessToken = _json[K.OAuth2Credential.kAccessTokenKey] as? String else { throw JSONParsingError.FieldNotFound }
        guard let tokenType = _json[K.OAuth2Credential.kTokenTypeKey] as? String else { throw JSONParsingError.FieldNotFound }
        
        let credential = OAuth2Credential(withAccessToken: accessToken, tokenType: tokenType)
        
        if let refreshToken = _json[K.OAuth2Credential.kRefreshTokenKey] as? String {
            credential.refreshToken = refreshToken
        }
        if let expiresIn = _json[K.OAuth2Credential.kExpirationKey] as? Double {
            credential.expiration = NSDate(timeIntervalSinceNow: expiresIn)
        } else {
            credential.expiration = NSDate.distantFuture()
        }
        
        return credential
    }
}

// MARK: Class functions

extension OAuth2Credential {
    
    class func identifierWithClientId(clientId: String, clientSecret: String) -> String {
        return "\(clientId):\(clientSecret)"
    }
}