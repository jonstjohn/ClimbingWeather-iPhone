//
//  Area.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// A climbing area (Modern API v4.0)
struct Area: Codable, Identifiable, Hashable {
    /// Unique area identifier
    let areaId: Int
    
    /// ISO 3166 country code
    let country: String
    
    /// Administrative area code
    let adminArea: String
    
    /// Administrative area name
    let adminAreaName: String
    
    /// Area name
    let name: String
    
    /// Latitude in decimal degrees
    let latitude: String
    
    /// Longitude in decimal degrees
    let longitude: String
    
    /// Weather forecast (if days parameter provided)
    let forecast: Forecast?
    
    var id: Int { areaId }
    
    /// Latitude as Double
    var latitudeValue: Double? {
        Double(latitude)
    }
    
    /// Longitude as Double
    var longitudeValue: Double? {
        Double(longitude)
    }
}

/// Extended area information with all database fields
struct AreaDetail: Codable, Identifiable {
    /// Unique area identifier
    let areaId: Int
    
    /// Area name
    let name: String
    
    /// Latitude in decimal degrees
    let latitude: Double
    
    /// Longitude in decimal degrees
    let longitude: Double
    
    /// State/province code
    let stateCode: String
    
    /// Nearest city
    let city: String?
    
    /// Elevation in feet
    let elevation: Int?
    
    /// When area data was last updated
    let dataLastUpdated: Date?
    
    /// Area description
    let description: String?
    
    /// Whether weather is displayed for this area
    let showWeather: Bool
    
    /// Area size category identifier
    let areaSizeId: Int?
    
    /// Whether area is featured on front page
    let frontPage: Bool
    
    /// Climate station identifier for historical averages
    let clim81StationId: Int?
    
    /// Distance to climate station in miles
    let clim81StationDistance: Int?
    
    /// Primary ZIP code for the area
    let zipCode: String?
    
    /// Whether ZIP code has been indexed
    let zipCodeIndexed: Bool
    
    /// GMT offset in hours
    let gmtOffset: Int?
    
    /// Searchable name variant
    let nameSearch: String?
    
    /// Full climate station data with monthly averages (only included if includeClim81Station=true)
    let clim81Station: Clim81Station?
    
    var id: Int { areaId }
}

/// Area with request count (for popular areas)
struct PopularArea: Codable, Identifiable {
    /// Unique area identifier
    let areaId: Int
    
    /// ISO 3166 country code
    let country: String
    
    /// Administrative area code
    let adminArea: String
    
    /// Administrative area name (can be null in API responses)
    let adminAreaName: String?
    
    /// Area name
    let name: String
    
    /// Latitude in decimal degrees
    let latitude: String
    
    /// Longitude in decimal degrees
    let longitude: String
    
    /// Weather forecast (if days parameter provided)
    let forecast: Forecast?
    
    /// Number of requests for this area (may not be included in response)
    let requestCount: Int?
    
    var id: Int { areaId }
}
