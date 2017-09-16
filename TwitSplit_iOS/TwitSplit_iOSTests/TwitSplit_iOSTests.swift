//
//  TwitSplit_iOSTests.swift
//  TwitSplit_iOSTests
//
//  Created by dat on 9/15/17.
//  Copyright © 2017 dat. All rights reserved.
//

import XCTest
@testable import TwitSplit_iOS

class TwitSplit_iOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /// test valid number of character each split part
    ///
    /// - Parameter splits: all split part of message
    /// - Returns: return true if splits parts are valid, false if not
    func testValidEachPartOfSplitMessage(splits: [String]) -> Bool {
        for subMessage in splits {
            if subMessage.characters.count > 50 { return false }
        }
        return true
    }
    
    /// function to test split message base on real case
    func testSplitMessage() {
        
        // case 1 valid value
        var message = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        var result = UtilFunctions.splitMessage(message)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 2)
        XCTAssertTrue(testValidEachPartOfSplitMessage(splits: result!))
        XCTAssertEqual(result?[0], "1/2 I can't believe Tweeter now supports chunking")
        XCTAssertEqual(result?[1], "2/2 my messages, so I don't have to do it myself.")
        
        // case 2 invalid value
        message = "Ican'tbelieveTweeternowsupportschunkingfailfailfail my messages, so I don't have to do it myself."
        result = UtilFunctions.splitMessage(message)
        XCTAssertNil(result)
        
        // case 3 empty string
        message = ""
        result = UtilFunctions.splitMessage(message)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[0], "")
        
        // case 4 string less than 50 value
        message = "I can't believe Tweeter now supports chunking"
        result = UtilFunctions.splitMessage(message)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[0], "I can't believe Tweeter now supports chunking")
        
    }
    
}
