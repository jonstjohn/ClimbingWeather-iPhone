//
//  XCUIElementDebugger.swift
//  MySudoDevUITests
//
//  Created by JSJ on 4/22/19.
//  Copyright © 2019 Anonyome Labs. All rights reserved.
//

import Foundation
import XCTest

class XCUIElementDebugger {
    
    let element: XCUIElement
    
    var queries: [String: XCUIElementQuery] {
       return [
        "buttons": self.element.buttons,
        "staticTexts": self.element.staticTexts,
        "otherElements": self.element.otherElements
        ]
    }
    
    init(_ element: XCUIElement) {
        self.element = element
    }
    
    public func getSuggestionOutput() -> String {
        
        var output = ""
        
        //for
        
        output.append("Buttons:\n")
        output.append(self.outputMatchingElementSuggestions(elements: self.element.buttons.allElementsBoundByIndex, label: "button"))
        output.append("\n\n")
    
        output.append("Static Texts:\n")
        output.append(self.outputMatchingElementSuggestions(elements: self.element.staticTexts.allElementsBoundByIndex, label: "staticText"))
        output.append("\n\n")
        
        output.append("Text Fields:\n")
        output.append(self.outputMatchingElementSuggestions(elements: self.element.textFields.allElementsBoundByIndex, label: "textField"))
        output.append("\n\n")
        
        output.append("Other Elements:\n")
        output.append(self.outputMatchingElementSuggestions(elements: self.element.otherElements.allElementsBoundByIndex, label: "other"))
        output.append("\n\n")
        
        //print("Static texts:")
        //self.outputMatchingElementSuggestions(elements: self.element.staticTexts.allElementsBoundByIndex, label: "staticTexts")
        
        //print("Other elements:")
        //self.outputMatchingElementSuggestions(elements: self.element.otherElements.allElementsBoundByIndex, label: "otherElements")
        
        return output
    }
    
    private func outputMatchingElementSuggestions(elements: [XCUIElement], label: String) -> String {
        
        var output = ""
        for element in elements {
            
            var locators: [String] = []
            
            if element.identifier.count > 0 {
                locators.append("Identifier: \(element.identifier)")
            }
            
            if element.label.count > 0 {
                locators.append("Label: \(element.label)")
            }
            
            if let placeholderValue = element.placeholderValue, placeholderValue.count > 0 {
                locators.append("PlaceholderValue: \(placeholderValue)")
            }
            
            if locators.count > 0 {
                let locatorStr = locators.joined(separator: " | ")
                output.append("(\(label)): \(locatorStr)\n")
            }
        }
        
        return output
    }
}
