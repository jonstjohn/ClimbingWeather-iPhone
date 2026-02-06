//
//  AreaAverages.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Historical climate averages (13 values - Jan through Dec plus annual)
struct AreaAverages: Codable, Identifiable {
    /// Area identifier
    let areaId: Int
    
    /// Monthly precipitation averages (inches) + annual
    let precip: [Double]
    
    /// Monthly high temperature averages (°F) + annual
    let high: [Double]
    
    /// Monthly low temperature averages (°F) + annual
    let low: [Double]
    
    /// Monthly mean temperature averages (°F) + annual
    let mean: [Double]
    
    var id: Int { areaId }
    
    /// Get precipitation for a specific month (1-12) or annual (13)
    func precipitation(for month: Int) -> Double? {
        guard month >= 1 && month <= 13 else { return nil }
        return precip[month - 1]
    }
    
    /// Get high temperature for a specific month (1-12) or annual (13)
    func highTemperature(for month: Int) -> Double? {
        guard month >= 1 && month <= 13 else { return nil }
        return high[month - 1]
    }
    
    /// Get low temperature for a specific month (1-12) or annual (13)
    func lowTemperature(for month: Int) -> Double? {
        guard month >= 1 && month <= 13 else { return nil }
        return low[month - 1]
    }
    
    /// Get mean temperature for a specific month (1-12) or annual (13)
    func meanTemperature(for month: Int) -> Double? {
        guard month >= 1 && month <= 13 else { return nil }
        return mean[month - 1]
    }
    
    /// Annual averages (index 12)
    var annualPrecipitation: Double { precip[12] }
    var annualHighTemperature: Double { high[12] }
    var annualLowTemperature: Double { low[12] }
    var annualMeanTemperature: Double { mean[12] }
}
