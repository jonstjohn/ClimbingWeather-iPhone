//
//  Country.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// A country with climbing areas
struct Country: Codable, Identifiable {
    /// ISO 3166 country code
    let iso: String
    
    /// Country name
    let name: String
    
    /// Number of administrative areas
    let adminAreaCount: Int
    
    /// Number of climbing areas
    let areaCount: Int
    
    var id: String { iso }
}
