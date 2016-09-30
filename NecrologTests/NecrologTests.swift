//
//  NecrologTests.swift
//  NecrologTests
//
//  Created by Jakub Hladík on 08.01.16.
//  Copyright © 2016 Jakub Hladík. All rights reserved.
//

import XCTest


@testable import Necrolog

class NecrologTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func necroPrint() {
        print("\n")
        Necrolog.verbose("verbose test 1 arg")
        Necrolog.debug("debug test 1 arg")
        Necrolog.info("info test 1 arg")
        Necrolog.warning("warning test 1 arg")
        Necrolog.error("error test 1 arg")
        
        Necrolog.verbose("verbose test", "2 args")
        Necrolog.debug("debug test", "2 args")
        Necrolog.info("info test", "2 args")
        Necrolog.warning("warning test", "2 args")
        Necrolog.error("error test", "2 args")
        
        Necrolog.verbose("verbose test", 2, 3)
        Necrolog.debug("debug test", [ 2, 3 ])
        Necrolog.info("info test", [ 2 : 3 ])
        Necrolog.warning("warning test", [ "key1" : "obj1", "key2" : "obj2" ])
        Necrolog.error("error test", NSError(domain: "Necrolog", code: 1, userInfo: [ "description" : "test error description" ]))
        print("\n")
    }
    
    func testBasic() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        self.necroPrint()
    }
    
    func testSingleLine() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        Necrolog.setup(withInitialTimeInterval: CACurrentMediaTime(), logLevel: .Verbose, withColors: false)
        
        self.necroPrint()
    }
    
    func testMultiLine() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        Necrolog.setup(withInitialTimeInterval: CACurrentMediaTime(), logLevel: .Verbose, splitMultipleArgs: true, withColors: false)
        
        self.necroPrint()
    }
    
    func testSingleLineColor() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        Necrolog.setup(withInitialTimeInterval: CACurrentMediaTime(), logLevel: .Verbose, withColors: true)
        
        self.necroPrint()
    }
    
    func testMultiLineColor() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        Necrolog.setup(withInitialTimeInterval: CACurrentMediaTime(), logLevel: .Verbose, splitMultipleArgs: true, withColors: true)
        
        self.necroPrint()
    }
    
    func testSingleLineColorNoLocation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        Necrolog.setup(withInitialTimeInterval: CACurrentMediaTime(), logLevel: .Verbose, logCodeLocation: false, withColors: true)
        
        self.necroPrint()
    }
    
    func testMultiLineColorNoLocation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        Necrolog.setup(withInitialTimeInterval: CACurrentMediaTime(), logLevel: .Verbose, splitMultipleArgs: true, logCodeLocation: false, withColors: true)
        
        self.necroPrint()
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
