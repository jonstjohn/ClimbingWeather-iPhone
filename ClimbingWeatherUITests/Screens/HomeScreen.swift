//
//  HomeScreen.swift
//  ClimbingWeatherUITests
//
//  Created by JSJ on 4/16/20.
//

import Foundation
import XCTest

class HomeScreen: Screen {
    
    var waitForElement: XCUIElement {
        return self.nearbyAreasButton
    }
    
    public var waitForTimeout: XCUIElementTimeout = .norton
    
    struct Identifiers {
        let nearbyAreasLabel = "Nearby Areas"
        let stateLabel = "By State"
    }
    
    let app: XCUIApplication
    let identifiers = Identifiers()
    
    let nearbyAreasButton: XCUIElement
    let stateButton: XCUIElement
    
    init(_ app: XCUIApplication) {
        self.app = app
        
        // Setup elements
        self.nearbyAreasButton = self.app.staticTexts[self.identifiers.nearbyAreasLabel].firstMatch
        self.stateButton = self.app.staticTexts[self.identifiers.stateLabel]
    }
    
    func openNearbyAreas() {
        self.nearbyAreasButton.tap()
    }
    
    func openStates() {
        self.stateButton.tap()
    }
    
//    func lockApp() {
//        self.openHamburger()
//        self.lockAppButton.tap()
//    }
//
//    func openHamburger() {
//        self.hamburgerButton.tap()
//    }
    
}
