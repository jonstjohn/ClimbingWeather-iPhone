//
//  AreasScreen.swift
//  ClimbingWeatherUITests
//
//  Created by JSJ on 4/16/20.
//

import Foundation
import XCTest

class StatesScreen: Screen {
    
    var waitForElement: XCUIElement {
        return self.stateText
    }
    
    public var waitForTimeout: XCUIElementTimeout = .norton
    
    struct Identifiers {
        let stateLabel = "Utah"
    }
    
    let app: XCUIApplication
    let identifiers = Identifiers()
    
    let stateText: XCUIElement
    
    init(_ app: XCUIApplication) {
        self.app = app
        
        // Setup elements
        self.stateText = self.app.staticTexts[self.identifiers.stateLabel]
    }
    
    func openState() {
        self.stateText.tap()
    }
    
}
