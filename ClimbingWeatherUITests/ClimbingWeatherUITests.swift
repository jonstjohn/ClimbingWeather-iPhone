//
//  ClimbingWeatherUITests.swift
//  ClimbingWeatherUITests
//
//  Created by JSJ on 4/16/20.
//

import XCTest

class ClimbingWeatherUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSnapshot() {
        
        let app = XCUIApplication()
        
        // Ensure location usage is accepted
        addUIInterruptionMonitor(withDescription: "Allow “ClimbingWeather” to access your location?") { (alert) -> Bool in
            let button = alert.buttons["Allow While Using App"]
            print(alert.debugDescription)
            if button.exists {
                button.tap()
                app.activate()
                return true // The alert was handled
            }

            return false // The alert was not handled
            
        }
        
        // Launch app
        setupSnapshot(app)
        app.launch()
        
        // Home Screen
        let homeScreen = HomeScreen(app)
        homeScreen.waitFor()
        snapshot("01Home")
        
        
        // Nearby Areas Screen
        homeScreen.openNearbyAreas()
        let nearbyAreasScreen = NearbyAreasScreen(app)
        nearbyAreasScreen.tap() // Tap will trigger handling the location prompt, if it occurs
        nearbyAreasScreen.waitFor()
        snapshot("02NearbyAreas")
        nearbyAreasScreen.home()
        
        // UT screen
        homeScreen.waitFor()
        homeScreen.openStates()

        let statesScreen = StatesScreen(app)
        statesScreen.waitFor()
        statesScreen.openState()
        
        let areasScreen = AreasScreen(app)
        areasScreen.waitFor()
        snapshot("03StateAreas")
        
        areasScreen.openArea()
        let areaScreen = AreaScreen(app)
        areaScreen.waitFor()
        snapshot("04Area")
        
        // Map
        areaScreen.openMap()
        snapshot("05Map")
        
        sleep(5)
        
        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
