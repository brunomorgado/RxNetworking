//
//  EndpointTests.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 05/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import RxSwift
import RxNetworking
import Alamofire

class EndpointTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    
    let endpoint1 = EndpointTestsAPI.Endpoint1
    let endpoint2 = EndpointTestsAPI.Endpoint2("test")
    let endpoint3 = EndpointTestsAPI.Endpoint3
    let endpoint4 = EndpointTestsAPI.Endpoint4
    
    var endpoint1Snapshot: EndpointSnapshot {
        return endpoint1.snapshot()
    }
    var endpoint2Snapshot: EndpointSnapshot {
        return endpoint2.snapshot()
    }
    var endpoint3Snapshot: EndpointSnapshot {
        return endpoint3.snapshot()
    }
    var endpoint4Snapshot: EndpointSnapshot {
        return endpoint4.snapshot()
    }
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        
        
        super.tearDown()
    }
    
    func testSnapshotBaseUrlIsSame() {
        XCTAssertEqual(endpoint2.baseUrl, endpoint2Snapshot.baseUrl)
    }
    
    func testSnapshotPathIsSame() {
        XCTAssertEqual(endpoint2.path, endpoint2Snapshot.path)
    }
    
    func testSnapshotParametersAreSame() {
        let encodings = endpoint2.parameters
        let snapshotEncodings = endpoint2Snapshot.parameters
        
        XCTAssertNotNil(encodings)
        XCTAssertNotNil(snapshotEncodings)
        XCTAssertEqual(encodings!.count, snapshotEncodings!.count)
        
        for (encoding, parameters) in encodings! {
            let snapshotParameters = snapshotEncodings![encoding]
            XCTAssertNotNil(snapshotParameters)
            XCTAssertEqual(parameters.count, snapshotParameters!.count)
            
            for (key, _) in parameters {
                let snapshotParametersValue = snapshotParameters![key]
                XCTAssertNotNil(snapshotParametersValue)
            }
        }
    }
    
    func testSnapshotMethodIsSame() {
        XCTAssertEqual(endpoint2.method, endpoint2Snapshot.method)
    }
    
    func testSnapshotHeadersAreSame() {
        let headers = endpoint2.headers
        let snapshotHeaders = endpoint2Snapshot.headers
        
        XCTAssertNotNil(headers)
        XCTAssertNotNil(snapshotHeaders)
        XCTAssertEqual(headers!.count, snapshotHeaders!.count)
        XCTAssertEqual(headers!, snapshotHeaders!)
    }
    
    func testFullUrl() {
        XCTAssertEqual(endpoint1Snapshot.fullUrl(), "https://api.rx networking.sample/endpoint".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()))
        XCTAssertEqual(endpoint2Snapshot.fullUrl(), "https://api.rx networking.sample/endpoint/test".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()))
        XCTAssertEqual(endpoint3Snapshot.fullUrl(), "https://api.rx networking.sample/endpoint".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()))
        XCTAssertEqual(endpoint4Snapshot.fullUrl(), "https://api.rx networking.sample/endpoint".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()))
    }
    
    func testParametersEncodedInUrl() {
        let methods: [Alamofire.Method] = [.OPTIONS, .GET, .HEAD, .POST, .PUT, .PATCH, .DELETE, .TRACE, .CONNECT]
        let encodings: [Alamofire.ParameterEncoding] = [.URL, .URLEncodedInURL, .JSON]
        
        methods.forEach { method in
            XCTAssertTrue(EndpointSnapshot.parametersEncodedInURL(withEncoding: .URLEncodedInURL, method: method))
        }
        
        encodings.forEach { encoding in
            methods.forEach { method in
                if encoding == .URLEncodedInURL {
                    XCTAssertTrue(EndpointSnapshot.parametersEncodedInURL(withEncoding: encoding, method: method))
                } else {
                    switch method {
                    case .GET, .HEAD, .DELETE:
                        XCTAssertTrue(EndpointSnapshot.parametersEncodedInURL(withEncoding: encoding, method: method))
                    default:
                        XCTAssertFalse(EndpointSnapshot.parametersEncodedInURL(withEncoding: encoding, method: method))
                    }
                }
            }
        }
    }
    
    func testGetBodyParameters() {
        // Method: .GET => no body parameters
        var bodyParameters = endpoint1Snapshot.getBodyParameters()
        XCTAssertNil(bodyParameters)
        
        // Method: .POST => URL and JSON are body parameters
        bodyParameters = endpoint2Snapshot.getBodyParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 11)
        
        // Method: .PUT => URL and JSON are body parameters
        bodyParameters = endpoint3Snapshot.getBodyParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 11)
        
        // Method: .DELETE => no body parameters
        bodyParameters = endpoint4Snapshot.getBodyParameters()
        XCTAssertNil(bodyParameters)
    }
    
    func testGetURLEncodedInUrlParameters() {
        // Method: .GET => all parameters are url parameters
        var bodyParameters = endpoint1Snapshot.getURLEncodedInURLParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 16)
        
        // Method: .POST => no url parameters
        bodyParameters = endpoint2Snapshot.getURLEncodedInURLParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 5)
        
        // Method: .PUT => no url parameters
        bodyParameters = endpoint3Snapshot.getURLEncodedInURLParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 5)
        
        // Method: .DELETE => all parameters are url parameters
        bodyParameters = endpoint4Snapshot.getURLEncodedInURLParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 16)
    }
    
    func testGetURLEncodedInBodyParameters() {
        // Method: .GET => no url encoded in body params
        var bodyParameters = endpoint1Snapshot.getURLEncodedInBodyParameters()
        XCTAssertNil(bodyParameters)
        
        // Method: .POST => no url parameters
        bodyParameters = endpoint2Snapshot.getURLEncodedInBodyParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 6)
        
        // Method: .PUT => no url parameters
        bodyParameters = endpoint3Snapshot.getURLEncodedInBodyParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 6)
        
        // Method: .DELETE => no url encoded in body params
        bodyParameters = endpoint4Snapshot.getURLEncodedInBodyParameters()
        XCTAssertNil(bodyParameters)
    }
    
    func testGetJSONEncodedInBodyParameters() {
        // Method: .GET => no url encoded in body params
        var bodyParameters = endpoint1Snapshot.getJSONEncodedInBodyParameters()
        XCTAssertNil(bodyParameters)
        
        // Method: .POST => no url parameters
        bodyParameters = endpoint2Snapshot.getJSONEncodedInBodyParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 5)
        
        // Method: .PUT => no url parameters
        bodyParameters = endpoint3Snapshot.getJSONEncodedInBodyParameters()
        XCTAssertNotNil(bodyParameters)
        XCTAssertEqual(bodyParameters?.count, 5)
        
        // Method: .DELETE => no url encoded in body params
        bodyParameters = endpoint4Snapshot.getJSONEncodedInBodyParameters()
        XCTAssertNil(bodyParameters)
    }
}
