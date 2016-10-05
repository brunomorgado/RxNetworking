//
//  SampleAPI.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 05/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Alamofire
import RxSwift
import RxNetworking

public enum EndpointTestsAPI: Endpoint {
    case Endpoint1
    case Endpoint2(String)
    case Endpoint3
    case Endpoint4
}

extension EndpointTestsAPI {
    public var baseUrl: String {
        switch self {
        case .Endpoint1:
            return "https://api.rx networking.sample"
        case .Endpoint2:
            return "https://api.rx networking.sample/"
        case .Endpoint3:
            return "https://api.rx networking.sample/"
        case .Endpoint4:
            return "https://api.rx networking.sample"
        }
    }
    
    public var path: String {
        switch self {
        case .Endpoint1:
            return "/endpoint"
        case .Endpoint2(let param):
            return "endpoint/" + param
        case .Endpoint3:
            return "/endpoint"
        case .Endpoint4:
            return "endpoint"
        }
    }
    
    public var parameters: [Alamofire.ParameterEncoding: [String: AnyObject]]? {
        switch self {
            
        case .Endpoint1:
            return [.JSON: [
                "grant_type": "password",
                "client_id": "client_id",
                "client_secret":  "client_secret",
                "username": "username",
                "password": "password",
                "redirect_uri": "https://park.we-vw.de/v1/user"
                ]]
            
        case .Endpoint2:
            return [.JSON: [
                "grant_type": "refresh_token",
                "client_id": "client_id",
                "client_secret":  "client_secret",
                "refresh_token": "refresh_token",
                "redirect_uri": "https://park.we-vw.de/v1/user"
                ]]
        default: return nil
        }
    }
    
    public var method: Alamofire.Method {
        switch self {
        case .Endpoint1:
            return .POST
        case .Endpoint2:
            return .GET
        default: return .GET
        }
    }
    
    public var headers: [String: String]? {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }
    public var validation: Request.Validation? {
        return nil
    }
    public var errorMapping: ErrorMapping? {
        return nil
    }
    public var sampleData: AnyObject? {
        return nil
    }
}
