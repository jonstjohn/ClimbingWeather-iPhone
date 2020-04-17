//
//  AreaScreen.swift
//  ClimbingWeatherUITests
//
//  Created by JSJ on 4/16/20.
//

import Foundation
import XCTest

class AreaScreen: Screen {
    
    var waitForElement: XCUIElement {
        return self.todayText
    }
    
    public var waitForTimeout: XCUIElementTimeout = .norton
    
    struct Identifiers {
        let todayLabel = "Today"
        let mapLabel = "Map"
    }
    
    let app: XCUIApplication
    let identifiers = Identifiers()
    
    let todayText: XCUIElement
    let mapButton: XCUIElement
    
    init(_ app: XCUIApplication) {
        self.app = app
        
        // Setup elements
        self.todayText = self.app.staticTexts[self.identifiers.todayLabel]
        self.mapButton = self.app.buttons[self.identifiers.mapLabel]
    }
    
    func openMap() {
        self.mapButton.tap()
        self.app.maps.firstMatch.waitForExistence(timeout: .element)
    }
    
}

