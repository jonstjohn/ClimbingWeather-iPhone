//
//  StatesTests.swift
//  climbingweather
//
//  Created by Jon St. John on 2/3/17.
//
//

import XCTest

@testable import ClimbingWeather

class StatesTests: XCTestCase {
    
    let jsonStr = "[{\"code\":\"AK\",\"name\":\"Alaska\",\"areas\":\"3\"},{\"code\":\"AL\",\"name\":\"Alabama\",\"areas\":\"13\"},{\"code\":\"AR\",\"name\":\"Arkansas\",\"areas\":\"9\"}]"
    
    let invalidJsonStr = "[\"test\", \"blah\"]"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_validJson() {
        let states = States(jsonStr: jsonStr)
        XCTAssertEqual(states?.states[0].name, "Alaska")
        XCTAssertEqual(states?.states[0].areas, 3)
        XCTAssertEqual(states?.states[0].code, "AK")
    }
    
    func test_invalidJson() {
        let states = States(jsonStr: invalidJsonStr)
        XCTAssertNil(states)
    }
    
    func test_fetchStates() {
        let ex = expectation(description: "Wait for load.")
        var states: States?
        States.fetchStates { (fetchedStates) in
            states = fetchedStates
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(states)
    }
    
}
