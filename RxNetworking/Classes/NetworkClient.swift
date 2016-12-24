//
//  NetworkClient.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 14/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Alamofire
import RxSwift

enum NetworkClientError: Error {
    case unknown
}

public protocol NetworkClientProtocol {
    init()
    init(withSessionConfiguration sessionConfiguration: URLSessionConfiguration)
    init(withSessionManager sessionManager: SessionManager)
    
    func request(withEndpoint endpoint: Endpoint) -> Observable<Any>
    func request(withEndpoint endpoint: Endpoint, authenticator: Authenticator?) -> Observable<Any>
}

public final class NetworkClient: NetworkClientProtocol {
    fileprivate let sessionManager: SessionManager
    
    public init() {
        self.sessionManager = SessionManager()
    }
    
    public init(withSessionConfiguration sessionConfiguration: URLSessionConfiguration) {
        self.sessionManager = SessionManager(configuration: sessionConfiguration)
    }
    
    public init(withSessionManager sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    public func request(withEndpoint endpoint: Endpoint) -> Observable<Any> {
        return request(withEndpoint: endpoint, authenticator: nil)
    }
    
    public func request(withEndpoint endpoint: Endpoint, authenticator: Authenticator?) -> Observable<Any> {
        if let sampleData = endpoint.sampleData {
            return Observable.just(sampleData)
        }
        
        let endpointSnapshot = endpoint.snapshot()
        let request: Observable<Any>
        
        if let _authenticator = authenticator {
            
            /*
             Needs authentication
             */
            
            request = _authenticator.authorizationHeader()
                .map{(endpointSnapshot, $0)}
                .flatMap(toAuthenticatedRequest)
            
        } else {
            
            /*
             No need for authentication
             */
            
            request = genericRequest(withEndpoint: endpointSnapshot)
        }
        
        return request
    }
}

private extension NetworkClient {
    
    func toAuthorizationHeader(_ authField: String) -> [String: String] {
        return [K.Authenticator.kAuthHeaderKey: authField]
    }
    
    func toAuthenticatedRequest(_ endpoint: EndpointSnapshot, authorizationHeader: [String: String]) -> Observable<Any> {
        var authenticatedEndpoint = endpoint
        authenticatedEndpoint.headers += authorizationHeader
        return genericRequest(withEndpoint: authenticatedEndpoint)
    }
    
    func genericRequest(
        withEndpoint endpoint: EndpointSnapshot) -> Observable<Any> {
        return Observable.create { [unowned self] observer in
            let request = self.sessionManager.request(endpoint.fullUrl(), method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding, headers: endpoint.headers)
                .validate(withValidation: endpoint.validation)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(endpoint.errorMapping?(response) ?? error)
                    }
                })
            return Disposables.create(with: { request.cancel() })
        }
    }
}

extension DataRequest {
    func validate(withValidation validation: Validation?) -> Self {
        guard let _validation = validation else {
            return validate()
        }
        return validate(_validation)
    }
}
