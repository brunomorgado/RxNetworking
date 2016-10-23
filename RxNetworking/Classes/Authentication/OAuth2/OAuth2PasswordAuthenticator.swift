//
//  OAuth2PasswordAuthenticator.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 14/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import RxSwift
import Alamofire

public protocol OAuth2PasswordAuthenticatorDataSource {
    func clientId() -> String
    func clientSecret() -> String
    func tokenEndpoint() throws -> Endpoint
    func tokenEndpoint(withRefreshToken refreshToken: String) -> Endpoint
}

public final class OAuth2PasswordAuthenticator {
    public var dataSource: OAuth2PasswordAuthenticatorDataSource?
    
    private let networkClient: NetworkClientProtocol
    private let authenticator: Authenticator?
    private var credentialStore: CredentialStore
    private let disposeBag = DisposeBag()
    
    public init(withNetworkClient networkClient: NetworkClientProtocol, authenticator: Authenticator? = nil, credentialStore: CredentialStore = OAuth2DefaultsCredentialStore()) {
        self.networkClient = networkClient
        self.credentialStore = credentialStore
        self.authenticator = authenticator
    }
    
    public func authorize() throws -> Observable<Bool> {
        return networkClient.request(withEndpoint: try dataSource!.tokenEndpoint(), authenticator: authenticator)
            .map(toCredential)
            .doOnNext(storeCredential)
            .map { _ in true}
            .catchErrorJustReturn(false)
    }
    
    public func unauthorize() throws {
        try credentialStore.deleteCredential(withIdentifier: OAuth2Credential.identifierWithClientId(dataSource!.clientId(), clientSecret: dataSource!.clientSecret()))
    }
    
    public func isAuthorized() -> Bool {
        let credential = getCredential()
        return credential != nil
    }
}

// MARK: Authenticator protocol

extension OAuth2PasswordAuthenticator: Authenticator {
    public func authorizationHeader() -> Observable<[String : String]> {
        let headerKeyObservable = Observable.just(K.Authenticator.kAuthHeaderKey)
        let headerValueObservable = authHeaderField()
        return Observable.zip(headerKeyObservable, headerValueObservable) { ($0, $1) }
            .map { (headerKey, headerValue) in
                [headerKey: headerValue]
            }
    }
}

// MARK: Private

private extension OAuth2PasswordAuthenticator {
    
    func authHeaderField() -> Observable<String> {
        var credentialSignal: Observable<OAuth2Credential>
        
        guard let _credential = getCredential() else {
            debugPrint("Authenticator \(self) was unable to authenticate with credential.")
            return Observable.just("")
        }
        
        if !_credential.isExpired {
            credentialSignal = Observable.just(_credential)
        } else if let refreshToken = _credential.refreshToken {
            credentialSignal = networkClient.request(withEndpoint: dataSource!.tokenEndpoint(withRefreshToken: refreshToken), authenticator: authenticator)
                .map(toCredential)
                .doOnNext(storeCredential)
        } else {
            debugPrint("Authenticator \(self) was unable to authenticate with refresh token.")
            return Observable.just("")
        }
        
        return credentialSignal
            .map(toOAuth2HeaderField)
    }
    
    func toOAuth2HeaderField(credential: OAuth2Credential) throws -> String {
        return "Bearer \(credential.accessToken)"
    }
    
    func toCredential(json: AnyObject) throws -> OAuth2Credential {
        return try OAuth2Credential.fromJSON(json)
    }
    
    func getCredential() -> OAuth2Credential? {
        let identifier = OAuth2Credential.identifierWithClientId(dataSource!.clientId(), clientSecret: dataSource!.clientSecret())
        guard let credential = try? credentialStore.retrieveCredential(withIdentifier: identifier) as? OAuth2Credential else {
            return nil
        }
        return credential
    }
    
    func storeCredential(credential: OAuth2Credential) throws {
        try credentialStore.storeCredential(credential, withIdentifier: OAuth2Credential.identifierWithClientId(dataSource!.clientId(), clientSecret: dataSource!.clientSecret()))
    }
}
