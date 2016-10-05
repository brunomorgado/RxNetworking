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
        XCTAssertEqual(endpoint1Snapshot.fullUrl(), "https://api.rx%20networking.sample/endpoint")
        XCTAssertEqual(endpoint2Snapshot.fullUrl(), "https://api.rx%20networking.sample/endpoint/test")
        XCTAssertEqual(endpoint3Snapshot.fullUrl(), "https://api.rx%20networking.sample/endpoint")
        XCTAssertEqual(endpoint4Snapshot.fullUrl(), "https://api.rx%20networking.sample/endpoint")
    }
}
