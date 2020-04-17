//
//  AreasScreen.swift
//  ClimbingWeatherUITests
//
//  Created by JSJ on 4/16/20.
//

import Foundation
import XCTest

class AreasScreen: Screen {
    
    var waitForElement: XCUIElement {
        return self.areaText
    }
    
    public var waitForTimeout: XCUIElementTimeout = .norton
    
    struct Identifiers {
        let areaLabel = "Indian Creek"
    }
    
    let app: XCUIApplication
    let identifiers = Identifiers()
    
    let areaText: XCUIElement
    
    init(_ app: XCUIApplication) {
        self.app = app
        
        // Setup elements
        self.areaText = self.app.staticTexts[self.identifiers.areaLabel]
    }
    
    func openArea() {
        self.areaText.tap()
    }
    
}
