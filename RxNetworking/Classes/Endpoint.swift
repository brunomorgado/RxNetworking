//
//  Endpoint.swift
//  Temp
//
//  Created by Bruno Morgado on 20/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Alamofire

public typealias ErrorMapping = Response<AnyObject, NSError> -> ErrorType

public protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [Alamofire.ParameterEncoding: [String: AnyObject]]? { get }
    var method: Alamofire.Method { get }
    var headers: [String: String]? { get }
    var validation: Request.Validation? { get }
    var errorMapping: ErrorMapping? { get }
    var sampleData: AnyObject? { get }
}

extension Endpoint {
    func snapshot() -> EndpointSnapshot {
        return EndpointSnapshot(
            baseUrl: self.baseUrl,
            path: self.path,
            parameters: self.parameters,
            method: self.method,
            headers: self.headers,
            validation: self.validation,
            errorMapping: self.errorMapping,
            sampleData: self.sampleData)
    }
}

struct EndpointSnapshot: Endpoint {
    var baseUrl: String
    var path: String
    var parameters: [Alamofire.ParameterEncoding: [String: AnyObject]]?
    var method: Alamofire.Method
    var headers: [String: String]?
    var validation: Request.Validation?
    var errorMapping: ErrorMapping?
    var sampleData: AnyObject?
}

extension EndpointSnapshot {
    func fullUrl() -> String {
        var formattedBaseUrl = baseUrl
        var formatterPath = path
        
        if formattedBaseUrl.characters.last == "/" {
            formattedBaseUrl = String(formattedBaseUrl.characters.dropLast())
        }
        if formatterPath.characters.first == "/" {
            formatterPath = String(formatterPath.characters.dropFirst())
        }
        
        let fullUrl = formattedBaseUrl + "/" + formatterPath
        let safeFullUrl = fullUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? fullUrl
        
        return safeFullUrl
    }
    
    func getBodyParameters() -> [String: AnyObject]? {
        return self.parameters?.reduce([String: String](), combine: { (curried, element) -> [String: AnyObject]? in
            var curried = curried
            if !parametersEncodedInURL(withEncoding: element.0, method: self.method) {
                curried += element.1
            }
            return curried
        })
    }
    
    func getURLEncodedInURLParameters() -> [String: AnyObject]? {
        return self.parameters?.reduce(nil, combine: { (curried, element) -> [String: AnyObject]? in
            var curried = curried
            if parametersEncodedInURL(withEncoding: element.0, method: self.method) {
                curried += element.1
            }
            return curried
        })
    }
    
    func getURLEncodedInBodyParameters() -> [String: AnyObject]? {
        return self.parameters?.reduce(nil, combine: { (curried, element) -> [String: AnyObject]? in
            guard element.0 == .URL else {
                return curried
            }
            var curried = curried
            if !parametersEncodedInURL(withEncoding: element.0, method: self.method) {
                curried += element.1
            }
            return curried
        })
    }
    
    func getJSONEncodedInBodyParameters() -> [String: AnyObject]? {
        return self.parameters?.reduce(nil, combine: { (curried, element) -> [String: AnyObject]? in
            guard element.0 == .JSON else {
                return curried
            }
            var curried = curried
            if !parametersEncodedInURL(withEncoding: element.0, method: self.method) {
                curried += element.1
            }
            return curried
        })
    }
    
    func parametersEncodedInURL(withEncoding encoding: Alamofire.ParameterEncoding, method: Alamofire.Method) -> Bool {
        switch encoding {
        case .URLEncodedInURL:
            return true
        default: break
        }
        
        switch method {
        case .GET, .HEAD, .DELETE:
            return true
        default:
            return false
        }
    }
}

extension Alamofire.ParameterEncoding: Hashable {
    public var hashValue : Int {
        return self.toInt()
    }

    private func toInt() -> Int {
        switch self {
        case .URL:
            return -1
        case .URLEncodedInURL:
            return 0
        case .JSON:
            return 1
        case .PropertyList:
            return 2
        case .Custom:
            return 3
        }
        
    }
}

public func == (lhs: Alamofire.ParameterEncoding, rhs: Alamofire.ParameterEncoding) -> Bool {
    return lhs.toInt() == rhs.toInt()
}
