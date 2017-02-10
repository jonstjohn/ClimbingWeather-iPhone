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
    var apiKey: String {
        return "iphone-VALID"
    }
    
    var tempUnits: TempUnits {
        return .Fahrenheit
    }
}
