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
    
    let jsonStr = "{\"status\":\"OK\",\"results\":[{\"id\":713,\"name\":\"Big Cottonwood Canyon\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":\"40\",\"l\":\"28\",\"pd\":\"56\",\"pn\":\"83\",\"sy\":\"snow4\"},{\"d\":\"2017-02-04\",\"hi\":\"39\",\"l\":\"30\",\"pd\":\"61\",\"pn\":\"13\",\"sy\":\"snow4\"},{\"d\":\"2017-02-05\",\"hi\":\"40\",\"l\":\"28\",\"pd\":\"8\",\"pn\":\"26\",\"sy\":\"cloudy3\"}]},{\"id\":714,\"name\":\"Little Cottonwood Canyon\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":\"40\",\"l\":\"29\",\"pd\":\"45\",\"pn\":\"68\",\"sy\":\"sleet\"},{\"d\":\"2017-02-04\",\"hi\":\"41\",\"l\":\"33\",\"pd\":\"50\",\"pn\":\"11\",\"sy\":\"sleet\"},{\"d\":\"2017-02-05\",\"hi\":\"43\",\"l\":\"31\",\"pd\":\"7\",\"pn\":\"23\",\"sy\":\"cloudy3\"}]},{\"id\":884,\"name\":\"Lone Peak Cirque\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":\"31\",\"l\":\"24\",\"pd\":\"52\",\"pn\":\"81\",\"sy\":\"snow4\"},{\"d\":\"2017-02-04\",\"hi\":\"29\",\"l\":\"24\",\"pd\":\"64\",\"pn\":\"14\",\"sy\":\"snow4\"},{\"d\":\"2017-02-05\",\"hi\":\"33\",\"l\":\"22\",\"pd\":\"9\",\"pn\":\"28\",\"sy\":\"cloudy3\"}]}]}"
    
    let invalidJsonStr = "{\"results\":[{\"id\":713,\"name\":\"Big Cottonwood Canyon\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":\"40\",\"l\":\"28\",\"pd\":\"56\",\"pn\":\"83\",\"sy\":\"snow4\"},{\"d\":\"2017-02-04\",\"hi\":\"39\",\"l\":\"30\",\"pd\":\"61\",\"pn\":\"13\",\"sy\":\"snow4\"},{\"d\":\"2017-02-05\",\"hi\":\"40\",\"l\":\"28\",\"pd\":\"8\",\"pn\":\"26\",\"sy\":\"cloudy3\"}]},{\"id\":714,\"name\":\"Little Cottonwood Canyon\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":\"40\",\"l\":\"29\",\"pd\":\"45\",\"pn\":\"68\",\"sy\":\"sleet\"},{\"d\":\"2017-02-04\",\"hi\":\"41\",\"l\":\"33\",\"pd\":\"50\",\"pn\":\"11\",\"sy\":\"sleet\"},{\"d\":\"2017-02-05\",\"hi\":\"43\",\"l\":\"31\",\"pd\":\"7\",\"pn\":\"23\",\"sy\":\"cloudy3\"}]},{\"id\":884,\"name\":\"Lone Peak Cirque\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":\"31\",\"l\":\"24\",\"pd\":\"52\",\"pn\":\"81\",\"sy\":\"snow4\"},{\"d\":\"2017-02-04\",\"hi\":\"29\",\"l\":\"24\",\"pd\":\"64\",\"pn\":\"14\",\"sy\":\"snow4\"},{\"d\":\"2017-02-05\",\"hi\":\"33\",\"l\":\"22\",\"pd\":\"9\",\"pn\":\"28\",\"sy\":\"cloudy3\"}]}]}"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_validJson() {
        let areas = Areas(dailyJsonStr: jsonStr)
        XCTAssertEqual(areas?.areas[0].name, "Big Cottonwood Canyon")
        XCTAssertEqual(areas?.areas[0].id, 713)
        XCTAssertEqual(areas?.areas[0].state, "UT")
        
        let daily = areas?.areas[0].daily
        XCTAssertNotNil(daily)
        XCTAssertEqual(daily!.count, 3)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        XCTAssertEqual(dateFormatter.string(from: daily![0].date), "2017-02-03")
        
        XCTAssertEqual(daily![0].high, 40)
        XCTAssertEqual(daily![0].low, 28)
        XCTAssertEqual(daily![0].precipitationChanceDay, 56)
        XCTAssertEqual(daily![0].precipitationChanceNight, 83)
        XCTAssertEqual(daily![0].symbol, Symbol.snow4)
    }
    
    func test_invalidJson() {
        let areas = Areas(dailyJsonStr: invalidJsonStr)
        XCTAssertNil(areas)
    }
    
    func test_fetchDaily() {
        let ex = expectation(description: "Wait for load.")
        var areas: Areas?
        Areas.fetchDaily(search: "blah") { (fetchedAreas) in
            areas = fetchedAreas
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(areas)
    }

    
}

class AreasHourlyTests: XCTest {
    
    let jsonStr = "{\"n\":\"New River Gorge\",\"f\":[{\"dy\":\"Today\",\"ti\":\"7:00 PM\",\"t\":\"25\",\"p\":\"0\",\"h\":\"50\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"6\",\"wg\":\"6\",\"w\":\"\",\"sy\":\"cloudy2_night\",\"sk\":\"38\",\"c\":\"\"},{\"dy\":\"Today\",\"ti\":\"10:00 PM\",\"t\":\"19\",\"p\":\"0\",\"h\":\"62\",\"r\":\"\",\"s\":null,\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"10\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"1:00 AM\",\"t\":\"16\",\"p\":\"0\",\"h\":\"67\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"4\",\"wg\":\"4\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"16\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"4:00 AM\",\"t\":\"13\",\"p\":\"0\",\"h\":\"80\",\"r\":\"\",\"s\":null,\"ws\":\"3\",\"wg\":\"3\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"9\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"7:00 AM\",\"t\":\"13\",\"p\":\"0\",\"h\":\"80\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"12\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"10:00 AM\",\"t\":\"22\",\"p\":\"0\",\"h\":\"52\",\"r\":\"\",\"s\":null,\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy1\",\"sk\":\"22\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"1:00 PM\",\"t\":\"34\",\"p\":\"0\",\"h\":\"24\",\"r\":\"0.00\",\"s\":\"0.00\",\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy2\",\"sk\":\"41\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"4:00 PM\",\"t\":\"36\",\"p\":\"0\",\"h\":\"24\",\"r\":null,\"s\":null,\"ws\":\"3\",\"wg\":\"3\",\"w\":\"\",\"sy\":\"cloudy2\",\"sk\":\"44\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"7:00 PM\",\"t\":\"29\",\"p\":\"13\",\"h\":\"29\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy2_night\",\"sk\":\"45\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"10:00 PM\",\"t\":\"27\",\"p\":\"13\",\"h\":\"40\",\"r\":\"\",\"s\":null,\"ws\":\"8\",\"wg\":\"8\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"65\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"1:00 AM\",\"t\":\"26\",\"p\":\"13\",\"h\":\"48\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"6\",\"wg\":\"6\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"60\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"4:00 AM\",\"t\":\"27\",\"p\":\"13\",\"h\":\"55\",\"r\":\"\",\"s\":null,\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"84\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"7:00 AM\",\"t\":\"30\",\"p\":\"24\",\"h\":\"66\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"5\",\"wg\":\"5\",\"w\":\"slight chance of light snow showers\",\"sy\":\"snow4\",\"sk\":\"84\",\"c\":\"Slight chance of light snow showers. \"},{\"dy\":\"Sun\",\"ti\":\"10:00 AM\",\"t\":\"37\",\"p\":\"24\",\"h\":\"67\",\"r\":null,\"s\":null,\"ws\":\"9\",\"wg\":\"12\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"73\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"1:00 PM\",\"t\":\"42\",\"p\":\"24\",\"h\":\"65\",\"r\":\"0.00\",\"s\":\"0.00\",\"ws\":\"9\",\"wg\":\"13\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"70\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"4:00 PM\",\"t\":\"44\",\"p\":\"24\",\"h\":\"62\",\"r\":null,\"s\":null,\"ws\":\"9\",\"wg\":\"12\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"60\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"7:00 PM\",\"t\":\"40\",\"p\":\"15\",\"h\":\"73\",\"r\":null,\"s\":null,\"ws\":\"6\",\"wg\":\"6\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"59\",\"c\":\"Slight chance of light rain showers. \"}]}"
    
    let invalidJsonStr = "{\"invalid\":\"New River Gorge\",\"f\":[{\"dy\":\"Today\",\"ti\":\"7:00 PM\",\"t\":\"25\",\"p\":\"0\",\"h\":\"50\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"6\",\"wg\":\"6\",\"w\":\"\",\"sy\":\"cloudy2_night\",\"sk\":\"38\",\"c\":\"\"},{\"dy\":\"Today\",\"ti\":\"10:00 PM\",\"t\":\"19\",\"p\":\"0\",\"h\":\"62\",\"r\":\"\",\"s\":null,\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"10\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"1:00 AM\",\"t\":\"16\",\"p\":\"0\",\"h\":\"67\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"4\",\"wg\":\"4\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"16\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"4:00 AM\",\"t\":\"13\",\"p\":\"0\",\"h\":\"80\",\"r\":\"\",\"s\":null,\"ws\":\"3\",\"wg\":\"3\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"9\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"7:00 AM\",\"t\":\"13\",\"p\":\"0\",\"h\":\"80\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"12\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"10:00 AM\",\"t\":\"22\",\"p\":\"0\",\"h\":\"52\",\"r\":\"\",\"s\":null,\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy1\",\"sk\":\"22\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"1:00 PM\",\"t\":\"34\",\"p\":\"0\",\"h\":\"24\",\"r\":\"0.00\",\"s\":\"0.00\",\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy2\",\"sk\":\"41\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"4:00 PM\",\"t\":\"36\",\"p\":\"0\",\"h\":\"24\",\"r\":null,\"s\":null,\"ws\":\"3\",\"wg\":\"3\",\"w\":\"\",\"sy\":\"cloudy2\",\"sk\":\"44\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"7:00 PM\",\"t\":\"29\",\"p\":\"13\",\"h\":\"29\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy2_night\",\"sk\":\"45\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"10:00 PM\",\"t\":\"27\",\"p\":\"13\",\"h\":\"40\",\"r\":\"\",\"s\":null,\"ws\":\"8\",\"wg\":\"8\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"65\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"1:00 AM\",\"t\":\"26\",\"p\":\"13\",\"h\":\"48\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"6\",\"wg\":\"6\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"60\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"4:00 AM\",\"t\":\"27\",\"p\":\"13\",\"h\":\"55\",\"r\":\"\",\"s\":null,\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"84\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"7:00 AM\",\"t\":\"30\",\"p\":\"24\",\"h\":\"66\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"5\",\"wg\":\"5\",\"w\":\"slight chance of light snow showers\",\"sy\":\"snow4\",\"sk\":\"84\",\"c\":\"Slight chance of light snow showers. \"},{\"dy\":\"Sun\",\"ti\":\"10:00 AM\",\"t\":\"37\",\"p\":\"24\",\"h\":\"67\",\"r\":null,\"s\":null,\"ws\":\"9\",\"wg\":\"12\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"73\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"1:00 PM\",\"t\":\"42\",\"p\":\"24\",\"h\":\"65\",\"r\":\"0.00\",\"s\":\"0.00\",\"ws\":\"9\",\"wg\":\"13\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"70\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"4:00 PM\",\"t\":\"44\",\"p\":\"24\",\"h\":\"62\",\"r\":null,\"s\":null,\"ws\":\"9\",\"wg\":\"12\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"60\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"7:00 PM\",\"t\":\"40\",\"p\":\"15\",\"h\":\"73\",\"r\":null,\"s\":null,\"ws\":\"6\",\"wg\":\"6\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"59\",\"c\":\"Slight chance of light rain showers. \"}]}"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /*
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
 */
}
