//
//  AreasTests.swift
//  climbingweather
//
//  Created by Jon St. John on 2/3/17.
//
//

import XCTest

@testable import ClimbingWeather

class AreasTests: XCTestCase {
    
    let jsonStr = "{\"status\":\"OK\",\"results\":[{\"id\":713,\"name\":\"Big Cottonwood Canyon\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":40,\"l\":\"28\",\"pd\":\"56\",\"pn\":\"83\",\"sy\":\"snow4\"},{\"d\":\"2017-02-04\",\"hi\":\"39\",\"l\":\"30\",\"pd\":\"61\",\"pn\":\"13\",\"sy\":\"snow4\"},{\"d\":\"2017-02-05\",\"hi\":\"40\",\"l\":\"28\",\"pd\":\"8\",\"pn\":\"26\",\"sy\":\"cloudy3\"}]},{\"id\":714,\"name\":\"Little Cottonwood Canyon\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":\"40\",\"l\":\"29\",\"pd\":\"45\",\"pn\":\"68\",\"sy\":\"sleet\"},{\"d\":\"2017-02-04\",\"hi\":\"41\",\"l\":\"33\",\"pd\":\"50\",\"pn\":\"11\",\"sy\":\"sleet\"},{\"d\":\"2017-02-05\",\"hi\":\"43\",\"l\":\"31\",\"pd\":\"7\",\"pn\":\"23\",\"sy\":\"cloudy3\"}]},{\"id\":884,\"name\":\"Lone Peak Cirque\",\"state\":\"UT\",\"f\":[{\"d\":\"2017-02-03\",\"hi\":\"31\",\"l\":\"24\",\"pd\":\"52\",\"pn\":\"81\",\"sy\":\"snow4\"},{\"d\":\"2017-02-04\",\"hi\":\"29\",\"l\":\"24\",\"pd\":\"64\",\"pn\":\"14\",\"sy\":\"snow4\"},{\"d\":\"2017-02-05\",\"hi\":\"33\",\"l\":\"22\",\"pd\":\"9\",\"pn\":\"28\",\"sy\":\"cloudy3\"}]}]}"
    
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
        Areas.fetchDaily(search: .Term("cottonwood")) { (fetchedAreas) in
            areas = fetchedAreas
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(areas)
    }

    
}

class AreaDailyTests: XCTestCase {
    let jsonStr = "{\"status\":\"OK\",\"results\":{\"n\":\"New River Gorge\",\"f\":[{\"d\":\"2017-02-06\",\"dy\":\"Today\",\"dd\":\"Feb 6\",\"hi\":\"59\",\"l\":\"32\",\"pd\":\"16\",\"pn\":\"48\",\"h\":\"50\",\"r\":\"0.04\",\"s\":\"0.01\",\"ws\":\"1\",\"wg\":\"3\",\"w\":\"blah blah\",\"sy\":\"cloudy1\",\"c\":\"0.04 inches rain possible. \"},{\"d\":\"2017-02-07\",\"dy\":\"Tue\",\"dd\":\"Feb 7\",\"hi\":\"67\",\"l\":\"48\",\"pd\":\"65\",\"pn\":\"65\",\"h\":\"67\",\"r\":\"0.35\",\"s\":\"0.00\",\"ws\":\"9\",\"wg\":\"32\",\"w\":\"light rain showers likely\",\"sy\":\"shower3\",\"c\":\"Light rain showers likely. 0.35 inches rain possible. \"},{\"d\":\"2017-02-08\",\"dy\":\"Wed\",\"dd\":\"Feb 8\",\"hi\":\"55\",\"l\":\"42\",\"pd\":\"52\",\"pn\":\"53\",\"h\":\"78\",\"r\":\"0.36\",\"s\":\"0.00\",\"ws\":\"5\",\"wg\":\"13\",\"w\":\"chance of moderate rain showers\",\"sy\":\"shower3\",\"c\":\"Chance of moderate rain showers. 0.36 inches rain possible. \"},{\"d\":\"2017-02-09\",\"dy\":\"Thu\",\"dd\":\"Feb 9\",\"hi\":\"33\",\"l\":\"28\",\"pd\":\"29\",\"pn\":\"15\",\"h\":\"71\",\"r\":null,\"s\":null,\"ws\":\"6\",\"wg\":null,\"w\":\"chance of light snow showers\",\"sy\":\"snow4\",\"c\":\"Chance of light snow showers. \"},{\"d\":\"2017-02-10\",\"dy\":\"Fri\",\"dd\":\"Feb 10\",\"hi\":\"43\",\"l\":\"21\",\"pd\":\"3\",\"pn\":\"10\",\"h\":\"57\",\"r\":null,\"s\":null,\"ws\":\"4\",\"wg\":null,\"w\":\"\",\"sy\":\"cloudy2\",\"c\":\"\"},{\"d\":\"2017-02-11\",\"dy\":\"Sat\",\"dd\":\"Feb 11\",\"hi\":\"53\",\"l\":\"33\",\"pd\":\"29\",\"pn\":\"47\",\"h\":\"68\",\"r\":null,\"s\":null,\"ws\":\"6\",\"wg\":null,\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"c\":\"Slight chance of light rain showers. \"},{\"d\":\"2017-02-12\",\"dy\":\"Sun\",\"dd\":\"Feb 12\",\"hi\":\"56\",\"l\":\"43\",\"pd\":\"46\",\"pn\":\"50\",\"h\":\"87\",\"r\":null,\"s\":null,\"ws\":\"8\",\"wg\":null,\"w\":\"chance of light rain showers\",\"sy\":\"shower3\",\"c\":\"Chance of light rain showers. \"}]}}"
    
    let errorJsonStr = "{\"status\":\"ERROR\"}"
    
    let malformedJsonStr = "{\"sdfdf["
    
    func test_validJson() {
        
        let data = self.jsonStr.data(using: .utf8)!
        guard let area = Area(id: 3, dailyJsonData: data) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(area.name, "New River Gorge")
        
        guard let daily = area.daily else {
            XCTFail()
            return
        }
        
        let day1 = daily[0]
        
        XCTAssertEqual(day1.high, 59)
        XCTAssertEqual(day1.low, 32)
        XCTAssertEqual(day1.precipitationChanceDay, 16)
        XCTAssertEqual(day1.precipitationChanceNight, 48)
        XCTAssertEqual(day1.precipitation?.rain, 0.04)
        XCTAssertEqual(day1.precipitation?.snow, 0.01)
        
        XCTAssertEqual(day1.conditions, "blah blah")
        XCTAssertEqual(day1.conditionsFormatted, "0.04 inches rain possible. ")
        
        XCTAssertEqual(day1.day, "Today")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        XCTAssertEqual(dateFormatter.string(from: day1.date), "2017-02-06")
        XCTAssertEqual(day1.dateFormatted, "Feb 6")
        
        XCTAssertEqual(day1.wind?.sustained, 1)
        XCTAssertEqual(day1.wind?.gust, 3)
        
    }
    
    func test_malformedJson() {
        let data = self.malformedJsonStr.data(using: .utf8)!
        XCTAssertNil(Area(id: 3, dailyJsonData: data))
    }
    
    func test_errorJson() {
        let data = self.errorJsonStr.data(using: .utf8)!
        XCTAssertNil(Area(id: 3, dailyJsonData: data))
    }
    
    func test_fetchArea() {
        let ex = expectation(description: "Wait for load.")
        var area: Area?
        Area.fetchDaily(id: 3) { (fetchedArea) in
            area = fetchedArea
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(area)
    }
    
}

class AreasHourlyTests: XCTestCase {
    
    let jsonStr = "{\"n\":\"New River Gorge\",\"f\":[{\"dy\":\"Today\",\"ti\":\"7:00 PM\",\"t\":\"25\",\"p\":\"12\",\"h\":\"50\",\"r\":\"0.01\",\"s\":\"0.05\",\"ws\":\"6\",\"wg\":\"8\",\"w\":\"slight chance of light rain showers\",\"sy\":\"cloudy2_night\",\"sk\":\"38\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Today\",\"ti\":\"10:00 PM\",\"t\":\"19\",\"p\":\"0\",\"h\":\"62\",\"r\":\"\",\"s\":null,\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"10\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"1:00 AM\",\"t\":\"16\",\"p\":\"0\",\"h\":\"67\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"4\",\"wg\":\"4\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"16\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"4:00 AM\",\"t\":\"13\",\"p\":\"0\",\"h\":\"80\",\"r\":\"\",\"s\":null,\"ws\":\"3\",\"wg\":\"3\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"9\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"7:00 AM\",\"t\":\"13\",\"p\":\"0\",\"h\":\"80\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"12\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"10:00 AM\",\"t\":\"22\",\"p\":\"0\",\"h\":\"52\",\"r\":\"\",\"s\":null,\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy1\",\"sk\":\"22\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"1:00 PM\",\"t\":\"34\",\"p\":\"0\",\"h\":\"24\",\"r\":\"0.00\",\"s\":\"0.00\",\"ws\":\"2\",\"wg\":\"2\",\"w\":\"\",\"sy\":\"cloudy2\",\"sk\":\"41\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"4:00 PM\",\"t\":\"36\",\"p\":\"0\",\"h\":\"24\",\"r\":null,\"s\":null,\"ws\":\"3\",\"wg\":\"3\",\"w\":\"\",\"sy\":\"cloudy2\",\"sk\":\"44\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"7:00 PM\",\"t\":\"29\",\"p\":\"13\",\"h\":\"29\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy2_night\",\"sk\":\"45\",\"c\":\"\"},{\"dy\":\"Sat\",\"ti\":\"10:00 PM\",\"t\":\"27\",\"p\":\"13\",\"h\":\"40\",\"r\":\"\",\"s\":null,\"ws\":\"8\",\"wg\":\"8\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"65\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"1:00 AM\",\"t\":\"26\",\"p\":\"13\",\"h\":\"48\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"6\",\"wg\":\"6\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"60\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"4:00 AM\",\"t\":\"27\",\"p\":\"13\",\"h\":\"55\",\"r\":\"\",\"s\":null,\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy3_night\",\"sk\":\"84\",\"c\":\"\"},{\"dy\":\"Sun\",\"ti\":\"7:00 AM\",\"t\":\"30\",\"p\":\"24\",\"h\":\"66\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"5\",\"wg\":\"5\",\"w\":\"slight chance of light snow showers\",\"sy\":\"snow4\",\"sk\":\"84\",\"c\":\"Slight chance of light snow showers. \"},{\"dy\":\"Sun\",\"ti\":\"10:00 AM\",\"t\":\"37\",\"p\":\"24\",\"h\":\"67\",\"r\":null,\"s\":null,\"ws\":\"9\",\"wg\":\"12\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"73\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"1:00 PM\",\"t\":\"42\",\"p\":\"24\",\"h\":\"65\",\"r\":\"0.00\",\"s\":\"0.00\",\"ws\":\"9\",\"wg\":\"13\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"70\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"4:00 PM\",\"t\":\"44\",\"p\":\"24\",\"h\":\"62\",\"r\":null,\"s\":null,\"ws\":\"9\",\"wg\":\"12\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"60\",\"c\":\"Slight chance of light rain showers. \"},{\"dy\":\"Sun\",\"ti\":\"7:00 PM\",\"t\":\"40\",\"p\":\"15\",\"h\":\"73\",\"r\":null,\"s\":null,\"ws\":\"6\",\"wg\":\"6\",\"w\":\"slight chance of light rain showers\",\"sy\":\"shower3\",\"sk\":\"59\",\"c\":\"Slight chance of light rain showers. \"}]}"
    
    let invalidJsonStr = "{\"invalid\":\"New River Gorge\",\"f\":[{\"dy\":\"Today\",\"ti\":\"7:00 PM\",\"t\":\"25\",\"p\":\"0\",\"h\":\"50\",\"r\":\"\",\"s\":\"0.00\",\"ws\":\"6\",\"wg\":\"6\",\"w\":\"\",\"sy\":\"cloudy2_night\",\"sk\":\"38\",\"c\":\"\"},{\"dy\":\"Today\",\"ti\":\"10:00 PM\",\"t\":\"19\",\"p\":\"0\",\"h\":\"62\",\"r\":\"\",\"s\":null,\"ws\":\"5\",\"wg\":\"5\",\"w\":\"\",\"sy\":\"cloudy1_night\",\"sk\":\"10\",\"c\":\"\"}]}"
    
    func test_validJson() {
        
        guard let data = self.jsonStr.data(using: .utf8) else {
            XCTFail("Failed to create data object from JSON string")
            return
        }
        
        
        guard let area = Area(id: 3, hourlyJsonData: data) else {
            XCTFail("Failed to create Area from hourly JSON data")
            return
        }
        
        XCTAssertEqual(area.name, "New River Gorge")
        
        guard let hourly = area.hourly else {
            XCTFail()
            return
        }
        
        let hour1 = hourly[0]
        XCTAssertEqual(hour1.day, "Today")
        XCTAssertEqual(hour1.time, "7:00 PM")
        XCTAssertEqual(hour1.temperature, 25)
        XCTAssertEqual(hour1.precipitationChance, 12)
        XCTAssertEqual(hour1.humidity, 50)
        XCTAssertEqual(hour1.precipitation?.rain, 0.01)
        XCTAssertEqual(hour1.precipitation?.snow, 0.05)
        XCTAssertEqual(hour1.wind?.sustained, 6)
        XCTAssertEqual(hour1.wind?.gust, 8)
        XCTAssertEqual(hour1.symbol, Symbol.cloudy2_night)
        XCTAssertEqual(hour1.conditions, "slight chance of light rain showers")
        XCTAssertEqual(hour1.conditionsFormatted, "Slight chance of light rain showers. ")
        XCTAssertEqual(hour1.sky, 38)
        
    }
    
    func test_invalidJson() {
        
        guard let data = self.invalidJsonStr.data(using: .utf8) else {
            XCTFail("Failed to create data object from JSON string")
            return
        }
        
        let area = Area(id: 3, hourlyJsonData: data)
        
        XCTAssertNil(area)
    }
    
    func test_fetchArea() {
        let ex = expectation(description: "Wait for load.")
        var area: Area?
        Area.fetchHourly(id: 3) { (fetchedArea) in
            area = fetchedArea
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(area)
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
