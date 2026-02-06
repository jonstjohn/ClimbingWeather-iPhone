//
//  Clim81Station.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// NOAA 1981-2010 Climate Normals station with monthly averages
struct Clim81Station: Codable, Identifiable {
    /// Unique station identifier
    let clim81StationId: Int
    
    /// State code
    let stateCode: String?
    
    /// Station number
    let number: String?
    
    /// COOP station identifier
    let coopid: String?
    
    /// Station name
    let stationName: String?
    
    /// Latitude in decimal degrees
    let latitude: Double?
    
    /// Longitude in decimal degrees
    let longitude: Double?
    
    /// Elevation in feet
    let elevation: Int?
    
    /// Monthly precipitation averages (inches) + annual (13 values - Jan-Dec + annual)
    let precip: [Double]?
    
    /// Monthly high temperature averages (°F) + annual (13 values)
    let high: [Double]?
    
    /// Monthly low temperature averages (°F) + annual (13 values)
    let low: [Double]?
    
    /// Monthly mean temperature averages (°F) + annual (13 values)
    let mean: [Double]?
    
    var id: Int { clim81StationId }
    
    /// Get precipitation for a specific month (1-12) or annual (13)
    func precipitation(for month: Int) -> Double? {
        guard let precip = precip, month >= 1 && month <= 13 else { return nil }
        return precip[month - 1]
    }
    
    /// Get high temperature for a specific month (1-12) or annual (13)
    func highTemperature(for month: Int) -> Double? {
        guard let high = high, month >= 1 && month <= 13 else { return nil }
        return high[month - 1]
    }
    
    /// Get low temperature for a specific month (1-12) or annual (13)
    func lowTemperature(for month: Int) -> Double? {
        guard let low = low, month >= 1 && month <= 13 else { return nil }
        return low[month - 1]
    }
    
    /// Get mean temperature for a specific month (1-12) or annual (13)
    func meanTemperature(for month: Int) -> Double? {
        guard let mean = mean, month >= 1 && month <= 13 else { return nil }
        return mean[month - 1]
    }
}
