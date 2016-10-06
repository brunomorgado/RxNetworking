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

public enum BasicAuthTestsAPI: Endpoint {
    case Endpoint1
    case Endpoint2(String)
    case Endpoint3
    case Endpoint4
}

extension BasicAuthTestsAPI {
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
            return [.URL: [
                "Key1": "Value1",
                "Key2": "Value2",
                "Key3":  "Value3",
                "Key4": "Value4",
                "Key5": "Value5",
                "Key6": "Value6"
                ],
                .URLEncodedInURL: [
                        "Key7": "Value7",
                        "Key8": "Value8",
                        "Key9":  "Value9",
                        "Key10": "Value10",
                        "Key11": "Value11"
                ],
                .JSON: [
                    "Key12": "Value12",
                    "Key13": "Value13",
                    "Key14":  "Value14",
                    "Key15": "Value16",
                    "Key16": "Value17"
                ]]
            
        case .Endpoint2:
            return  [.URL: [
                "Key1": "Value1",
                "Key2": "Value2",
                "Key3":  "Value3",
                "Key4": "Value4",
                "Key5": "Value5",
                "Key6": "Value6"
                ],
                     .URLEncodedInURL: [
                        "Key7": "Value7",
                        "Key8": "Value8",
                        "Key9":  "Value9",
                        "Key10": "Value10",
                        "Key11": "Value11"
                ],
                     .JSON: [
                        "Key12": "Value12",
                        "Key13": "Value13",
                        "Key14":  "Value14",
                        "Key15": "Value16",
                        "Key16": "Value17"
                ]]
            
        case .Endpoint3:
            return  [.URL: [
                "Key1": "Value1",
                "Key2": "Value2",
                "Key3":  "Value3",
                "Key4": "Value4",
                "Key5": "Value5",
                "Key6": "Value6"
                ],
                     .URLEncodedInURL: [
                        "Key7": "Value7",
                        "Key8": "Value8",
                        "Key9":  "Value9",
                        "Key10": "Value10",
                        "Key11": "Value11"
                ],
                     .JSON: [
                        "Key12": "Value12",
                        "Key13": "Value13",
                        "Key14":  "Value14",
                        "Key15": "Value16",
                        "Key16": "Value17"
                ]]
            
        case .Endpoint4:
            return  [.URL: [
                "Key1": "Value1",
                "Key2": "Value2",
                "Key3":  "Value3",
                "Key4": "Value4",
                "Key5": "Value5",
                "Key6": "Value6"
                ],
                     .URLEncodedInURL: [
                        "Key7": "Value7",
                        "Key8": "Value8",
                        "Key9":  "Value9",
                        "Key10": "Value10",
                        "Key11": "Value11"
                ],
                     .JSON: [
                        "Key12": "Value12",
                        "Key13": "Value13",
                        "Key14":  "Value14",
                        "Key15": "Value16",
                        "Key16": "Value17"
                ]]
        }
    }
    
    public var method: Alamofire.Method {
        switch self {
        case .Endpoint1:
            return .GET
        case .Endpoint2:
            return .POST
        case .Endpoint3:
            return .PUT
        case .Endpoint4:
            return .DELETE
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
