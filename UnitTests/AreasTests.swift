//
//  AreasTests.swift
//  climbingweather
//
//  Created by Jon St. John on 2/3/17.
//
//

import XCTest

@testable import Weather

class AreasTests: XCTestCase {
    
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
        let areas = Areas(jsonStr: jsonStr)
        XCTAssertEqual(areas?.areas[0].name, "Alaska")
        XCTAssertEqual(areas?.areas[0].areas, 3)
        XCTAssertEqual(areas?.areas[0].code, "AK")
    }
    
    func test_invalidJson() {
        let areas = Areas(jsonStr: invalidJsonStr)
        XCTAssertNil(areas)
    }

    
}
