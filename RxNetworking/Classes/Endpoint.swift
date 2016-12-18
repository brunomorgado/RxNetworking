//
//  Endpoint.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 20/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Alamofire

public typealias ErrorMapping = (DataResponse<Any>) -> Error

public protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var errorMapping: ErrorMapping? { get }
    var sampleData: AnyObject? { get }
}

public extension Endpoint {
    func snapshot() -> EndpointSnapshot {
        return EndpointSnapshot(
            baseUrl: self.baseUrl,
            path: self.path,
            parameters: self.parameters,
            encoding: self.encoding,
            method: self.method,
            headers: self.headers,
            errorMapping: self.errorMapping,
            sampleData: self.sampleData)
    }
}

public struct EndpointSnapshot: Endpoint {
    public var baseUrl: String
    public var path: String
    public var parameters: Parameters?
    public var encoding: ParameterEncoding
    public var method: HTTPMethod
    public var headers: HTTPHeaders?
    public var errorMapping: ErrorMapping?
    public var sampleData: AnyObject?
}

public extension EndpointSnapshot {
    public func fullUrl() -> String {
        var formattedBaseUrl = baseUrl
        var formatterPath = path
        
        if formattedBaseUrl.characters.last == "/" {
            formattedBaseUrl = String(formattedBaseUrl.characters.dropLast())
        }
        if formatterPath.characters.first == "/" {
            formatterPath = String(formatterPath.characters.dropFirst())
        }
        
        let fullUrl = formattedBaseUrl + "/" + formatterPath
        let safeFullUrl = fullUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? fullUrl
        
        return safeFullUrl
    }
}
