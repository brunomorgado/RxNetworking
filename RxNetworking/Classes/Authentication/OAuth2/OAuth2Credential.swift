//
//  OAuth2Credential.swift
//  RxNetworking
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

public final class OAuth2Credential: NSObject, NSCoding, Credential {
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
    
    public init(withAccessToken accessToken: String, tokenType: String, refreshToken: String? = nil, expiration: NSDate = NSDate.distantFuture()) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.expiration = expiration
    }
    
    // MARK: NSCoding
    
    public required convenience init?(coder decoder: NSCoder) {
        guard
            let accessToken = decoder.decodeObjectForKey(K.OAuth2Credential.kAccessTokenKey) as? String,
            let tokenType = decoder.decodeObjectForKey(K.OAuth2Credential.kTokenTypeKey) as? String
            else { return nil }
        
        let refreshToken: String? = decoder.decodeObjectForKey(K.OAuth2Credential.kRefreshTokenKey) as? String ?? nil
        let expiration: NSDate? = decoder.decodeObjectForKey(K.OAuth2Credential.kExpirationKey) as? NSDate ?? nil

        self.init(withAccessToken: accessToken, tokenType: tokenType, refreshToken: refreshToken, expiration: expiration ?? NSDate.distantFuture())
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(accessToken, forKey: K.OAuth2Credential.kAccessTokenKey)
        coder.encodeObject(tokenType, forKey: K.OAuth2Credential.kTokenTypeKey)
        if let _refreshToken = refreshToken {
            coder.encodeObject(_refreshToken, forKey: K.OAuth2Credential.kRefreshTokenKey)
        }
        coder.encodeObject(expiration, forKey: K.OAuth2Credential.kExpirationKey)
    }
}

// MARK: JSONAbleType

extension OAuth2Credential: JSONParsableType {
    
    public static func fromJSON(json: AnyObject?, refreshToken: String?) throws -> OAuth2Credential {
        guard let _json = json as? [String: AnyObject] else { throw JSONParsingError.InvalidJSON }
        
        guard let accessToken = _json[K.OAuth2Credential.kAccessTokenKey] as? String else { throw JSONParsingError.FieldNotFound }
        guard let tokenType = _json[K.OAuth2Credential.kTokenTypeKey] as? String else { throw JSONParsingError.FieldNotFound }
        
        let credential = OAuth2Credential(withAccessToken: accessToken, tokenType: tokenType)
        
        credential.refreshToken = _json[K.OAuth2Credential.kRefreshTokenKey] as? String ?? refreshToken
        
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
    
    public class func identifierWithClientId(clientId: String, clientSecret: String) -> String {
        return "\(clientId):\(clientSecret)"
    }
}
