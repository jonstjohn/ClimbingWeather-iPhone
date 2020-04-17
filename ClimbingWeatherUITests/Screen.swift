import Foundation
import XCTest

protocol Screen {
    var app: XCUIApplication { get }
    var waitForElement: XCUIElement { get }
    var waitForTimeout: XCUIElementTimeout { get }
    func waitFor(failAfterWait: Bool) -> Bool
    func printDebug()
    func isVisible() -> Bool
}

extension Screen {
    @discardableResult
    public func waitFor(failAfterWait: Bool = true) -> Bool {
        
        let result = self.waitForElement.waitForExistence(timeout: self.waitForTimeout)
        if !result && failAfterWait {
            print(self.app.debugDescription)
            let debugger = XCUIElementDebugger(self.app)
            print(debugger.getSuggestionOutput())
            XCTAssert(result, "\(String(describing: self)) failed to load")
        }
        return result
    }
    
    public func isVisible() -> Bool {
        return self.waitForElement.exists
    }
    
    public func printDebug() {
        let debugger = XCUIElementDebugger(self.app)
        print(debugger.getSuggestionOutput())
    }
}

enum XCUIElementTimeout: Double {
    case element = 3
    case screen = 5
    case network = 10
    case norton = 30
}

extension XCUIElement {
    
    /// Replace text in current field with new text
    func replaceText(_ text: String) {
        
        // Ensure focus
        self.tap()
        
        // Delete any text in the field
        if self.value != nil {
            guard let str = self.value as? String else {
                XCTFail("Element contains non-string value")
                return
            }
            
            self.tap()
        
            let deleteStr = str.map { _ in "\u{8}" }.joined(separator: "")
            self.typeText(deleteStr)
        }
        self.typeText(text)
    }
    
    func waitForExistence(timeout: XCUIElementTimeout) -> Bool {
        return self.waitForExistence(timeout: timeout.rawValue)
    }
    
}
