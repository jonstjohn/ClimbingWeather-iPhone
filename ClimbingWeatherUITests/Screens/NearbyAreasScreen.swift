//
//  NearbyAreasScreen.swift
//  ClimbingWeatherUITests
//
//  Created by JSJ on 4/16/20.
//

import Foundation
import XCTest

class NearbyAreasScreen: Screen {
    
    var waitForElement: XCUIElement {
        return self.firstAreaCell
    }
    
    public var waitForTimeout: XCUIElementTimeout = .norton
    
    let app: XCUIApplication
    
    var firstAreaCell: XCUIElement {
        return self.app.cells.firstMatch
    }
    
    init(_ app: XCUIApplication) {
        self.app = app
    }
    
    func home() {
        self.app.buttons["Home"].tap()
    }
    
    func tap() {
        self.app.windows.firstMatch.tap()
        //  self.app.staticTexts["Nearby"].firstMatch.tap()
    }
    
}

