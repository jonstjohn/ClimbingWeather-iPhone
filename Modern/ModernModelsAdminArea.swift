//
//  AdminArea.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Administrative area (state, province, etc.)
struct AdminArea: Codable, Identifiable {
    /// ISO 3166 country code
    let country: String
    
    /// Administrative area code
    let code: String
    
    /// Administrative area name
    let name: String
    
    /// Number of climbing areas
    let areaCount: Int
    
    /// List of climbing areas (if includeAreas=true)
    let areas: [Area]?
    
    var id: String { "\(country)-\(code)" }
}

/// Administrative area with geographic boundaries
struct AdminAreaBounds: Codable, Identifiable {
    /// ISO 3166 country code
    let country: String
    
    /// Administrative area code
    let code: String
    
    /// Administrative area name
    let name: String
    
    /// Number of climbing areas
    let areaCount: Int
    
    /// Southwest boundary latitude
    let swLatitude: Double
    
    /// Southwest boundary longitude
    let swLongitude: Double
    
    /// Northeast boundary latitude
    let neLatitude: Double
    
    /// Northeast boundary longitude
    let neLongitude: Double
    
    var id: String { "\(country)-\(code)" }
}
