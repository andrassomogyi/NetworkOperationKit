//
//  NetworkOperationTests.swift
//  NetworkOperationTests
//
//  Created by Somogyi András on 03/03/16.
//
//

import XCTest

@testable import NetworkOperationKit

class NetworkOperationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit () {
        let validURL = "https://www.apple.com"
        let invalidURL = ""
        let validNetworkOperation = NetworkOperation.init()
        let invalidNetworkOperation = NetworkOperation.init()
        
        validNetworkOperation.initNetworkOperation(validURL, successClosure: { (response) -> Void in
            XCTAssert(response != nil)
            }){ (error) -> Void in
                XCTAssert(error == nil)
        }
        
        invalidNetworkOperation.initNetworkOperation(invalidURL, successClosure: { (response) -> Void in
            XCTAssert(response == nil)
            }) { (error) -> Void in
                XCTAssert(error != nil)
        }
        
        let operationQueue = NSOperationQueue()
        operationQueue.suspended = true
        operationQueue.addOperation(validNetworkOperation)
        operationQueue.addOperation(invalidNetworkOperation)
        operationQueue.suspended = false
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}