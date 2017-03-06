//
//  Preference.swift
//  climbingweather
//
//  Created by Jon St. John on 2/6/17.
//
//

import Foundation

protocol PreferencesProtocol {
    var apiKey: String { get }
    var tempUnits: TempUnits { get }
}

struct Preferences: PreferencesProtocol {
    
    let tempUnitsKey = "tempUnits"
    
    var apiKey: String {
        return "iphone-VALID"
    }
    
    var tempUnits: TempUnits {
        get {
            if UserDefaults.standard.string(forKey: self.tempUnitsKey) == TempUnits.Celsius.asParameter() {
                return .Celsius
            } else {
                return .Fahrenheit
            }
        }
        set {
            UserDefaults.standard.set(newValue.asParameter(), forKey: self.tempUnitsKey)
        }
    }
}
