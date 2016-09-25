//
//  NetworkClient.swift
//  Temp
//
//  Created by Bruno Morgado on 14/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Alamofire
import RxSwift

enum NetworkClientError: ErrorType {
    case Unknown
}

public protocol NetworkClientProtocol {
    init()
    init(withSessionConfiguration sessionConfiguration: NSURLSessionConfiguration)
    
    func request(withEndpoint endpoint: Endpoint) -> Observable<AnyObject>
    func request(withEndpoint endpoint: Endpoint, authenticator: Authenticator?) -> Observable<AnyObject>
}

final class NetworkClient: NetworkClientProtocol {
    private let networkManager: Manager
    
    init() {
        self.networkManager = Manager()
    }
    
    init(withSessionConfiguration sessionConfiguration: NSURLSessionConfiguration) {
        self.networkManager = Manager(configuration: sessionConfiguration)
    }
    
    func request(withEndpoint endpoint: Endpoint) -> Observable<AnyObject> {
        return request(withEndpoint: endpoint, authenticator: nil)
    }
    
    func request(withEndpoint endpoint: Endpoint, authenticator: Authenticator?) -> Observable<AnyObject> {
        if let sampleData = endpoint.sampleData {
            return Observable.just(sampleData)
        }
        
        let endpointSnap = endpoint.snapshot()
        let request: Observable<AnyObject>
        
        if let _authenticator = authenticator {
            
            /*
             Needs authentication
             */
            
            request = _authenticator
                .authHeaderField()
                .map(toAuthorizationHeader)
                .map{(endpointSnap, $0)}
                .flatMap(toAuthenticatedRequest)
            
        } else {
            
            /*
             No need for authentication
             */
            
            request = genericRequest(withEndpoint: endpointSnap)
        }
        
        return request
    }
}

private extension NetworkClient {
    
    func toAuthorizationHeader(authField: String) -> [String: String] {
        return [K.Authenticator.kAuthHeaderKey: authField]
    }
    
    func toAuthenticatedRequest(endpoint: EndpointSnapshot, authorizationHeader: [String: String]) -> Observable<AnyObject> {
        var authenticatedEndpoint = endpoint
        authenticatedEndpoint.headers += authorizationHeader
        return genericRequest(withEndpoint: authenticatedEndpoint)
    }
    
    func genericRequest(
        withEndpoint endpoint: EndpointSnapshot) -> Observable<AnyObject> {
        return Observable.create { observer in
            do {
                let request = self.networkManager.request(try self.compositeRequest(withEndpoint: endpoint))
                    .validate(withValidation: endpoint.validation)
                    .responseJSON(completionHandler: { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                observer.onNext(value)
                                observer.onCompleted()
                            }
                        case .Failure(let error):
                            observer.onError(endpoint.errorMapping?(response) ?? error)
                        }
                    })
                return AnonymousDisposable {
                    request.cancel()
                }
            } catch let error {
                observer.onError(error)
                return NopDisposable.instance
            }
        }
    }
    
    func compositeRequest(withEndpoint endpoint: EndpointSnapshot) throws -> NSURLRequest {
        guard let URL = NSURL(string: endpoint.fullUrl()) else {
            throw NetworkClientError.Unknown
        }
        
        let compositeRequest = NSMutableURLRequest(URL: URL)
        compositeRequest.HTTPMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            for (headerField, headerValue) in headers {
                compositeRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        let urlEncodedInUrlParameters = endpoint.getURLEncodedInURLParameters()
        let urlEncodedInBodyParameters = endpoint.getURLEncodedInBodyParameters()
        let jsonEncodedInBodyParameters = endpoint.getJSONEncodedInBodyParameters()
        
        ParameterEncoding.URLEncodedInURL.encode(compositeRequest, parameters: urlEncodedInUrlParameters)
        
        guard let urlEncodedRequestCopy = compositeRequest.mutableCopy() as? NSMutableURLRequest else {
            throw NetworkClientError.Unknown
        }
        guard let jsonEncodedRequestCopy = compositeRequest.mutableCopy() as? NSMutableURLRequest else {
            throw NetworkClientError.Unknown
        }
        
        let urlEncodedInBodyRequest = ParameterEncoding.URL.encode(urlEncodedRequestCopy, parameters: urlEncodedInBodyParameters)
        let jsonEncodedInBodyRequest = ParameterEncoding.JSON.encode(jsonEncodedRequestCopy, parameters: jsonEncodedInBodyParameters)
        
        var compositeHTTPBody: NSMutableData?
        if let urlEncodedHTTPBody = urlEncodedInBodyRequest.0.HTTPBody {
            compositeHTTPBody = NSMutableData(data: urlEncodedHTTPBody)
            
            if let jsonEncodedHTTPBody = jsonEncodedInBodyRequest.0.HTTPBody {
                compositeHTTPBody?.appendData(jsonEncodedHTTPBody)
            }
        } else if let jsonEncodedHTTPBody = jsonEncodedInBodyRequest.0.HTTPBody {
            compositeHTTPBody = NSMutableData(data: jsonEncodedHTTPBody)
            
            if let urlEncodedHTTPBody = urlEncodedInBodyRequest.0.HTTPBody {
                compositeHTTPBody?.appendData(urlEncodedHTTPBody)
            }
        }
        
        compositeRequest.HTTPBody = compositeHTTPBody
        
        return compositeRequest
    }
}

extension Request {
    func validate(withValidation validation: Validation?) -> Self {
        guard let _validation = validation else {
            return validate()
        }
        return validate(_validation)
    }
}
