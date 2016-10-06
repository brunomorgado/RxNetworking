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

class BasicAuthTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    
    var networkClient: NetworkClient!
    var basicAuthenticator: BasicAuthenticator!
    var OAuth2Authenticator: OAuth2PasswordAuthenticator!
    
    let endpoint1 = BasicAuthTestsAPI.Endpoint1
    let endpoint2 = BasicAuthTestsAPI.Endpoint2("test")
    let endpoint3 = BasicAuthTestsAPI.Endpoint3
    let endpoint4 = BasicAuthTestsAPI.Endpoint4
    
    let username = "username"
    let password = "password"
    
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
        self.networkClient = NetworkClient()
        self.basicAuthenticator = BasicAuthenticator(withUsername: username, password: password)
        self.OAuth2Authenticator = OAuth2PasswordAuthenticator(withNetworkClient: networkClient)
    }
    
    override func tearDown() {
        
        
        super.tearDown()
    }
    
    func testBasicAuthHeader() {
        let expectation = expectationWithDescription("basicAuthHeader")
        var _header: [String: String]?
        
        basicAuthenticator.authorizationHeader()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { header in
                _header = header
                }, onError: { error in
                    
                }, onCompleted: {
                    expectation.fulfill()
                }
            ).addDisposableTo(disposeBag)
        
        waitForExpectationsWithTimeout(30) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertNotNil(_header)
            XCTAssertEqual(_header!.count, 1)
            
            let key = "Authorization"
            let value = _header![key]
            
            XCTAssertNotNil(value)
            
            let credentialData = "\(self.username):\(self.password)".dataUsingEncoding(NSUTF8StringEncoding)!
            let base64Credentials = credentialData.base64EncodedStringWithOptions([])
            
            let checkKey = "Authorization"
            let checkValue = "Basic \(base64Credentials)"
            
            XCTAssertEqual(key, checkKey)
            XCTAssertEqual(value, checkValue)
        }
    }
}
