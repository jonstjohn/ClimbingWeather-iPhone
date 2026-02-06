//
//  AreaRepository.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Protocol for area-related API operations
protocol AreaRepositoryProtocol {
    func searchAreas(query: String) async throws -> [Area]
    func getForecast(areaId: Int, days: Int, tempUnit: String?) async throws -> Forecast
    func getAreaDetail(areaId: Int, includeClimateStation: Bool) async throws -> AreaDetail
    func getAreaAverages(areaId: Int) async throws -> AreaAverages
    func getPopularAreas(limit: Int?, days: Int?) async throws -> [PopularArea]
    func getFrontPageAreas(days: Int?) async throws -> [Area]
    func listAreasByCountry(countryISO: String, days: Int?) async throws -> [Area]
    func listAreasByAdminArea(countryISO: String, adminArea: String, days: Int?) async throws -> [Area]
}

/// Repository for area-related operations
final class AreaRepository: AreaRepositoryProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    /// Search for climbing areas
    /// - Parameter query: Search query (area name, ZIP code, lat/lon, etc.)
    /// - Returns: Array of matching areas
    func searchAreas(query: String) async throws -> [Area] {
        let endpoint = ClimbingWeatherEndpoint.searchAreas(query: query)
        return try await apiClient.request(endpoint)
    }
    
    /// Get weather forecast for an area
    /// - Parameters:
    ///   - areaId: Area identifier
    ///   - days: Number of forecast days (1-7)
    ///   - tempUnit: Temperature unit ("f" or "c")
    /// - Returns: Weather forecast
    func getForecast(areaId: Int, days: Int = 7, tempUnit: String? = nil) async throws -> Forecast {
        let endpoint = ClimbingWeatherEndpoint.getAreaForecast(
            areaId: areaId,
            tempUnit: tempUnit,
            startDate: nil,
            days: days
        )
        return try await apiClient.request(endpoint)
    }
    
    /// Get detailed information about an area
    /// - Parameters:
    ///   - areaId: Area identifier
    ///   - includeClimateStation: Whether to include full climate station data
    /// - Returns: Area details
    func getAreaDetail(areaId: Int, includeClimateStation: Bool = false) async throws -> AreaDetail {
        let endpoint = ClimbingWeatherEndpoint.getAreaDetail(
            areaId: areaId,
            includeClim81Station: includeClimateStation
        )
        return try await apiClient.request(endpoint)
    }
    
    /// Get historical climate averages for an area
    /// - Parameter areaId: Area identifier
    /// - Returns: Climate averages
    func getAreaAverages(areaId: Int) async throws -> AreaAverages {
        let endpoint = ClimbingWeatherEndpoint.getAreaAverages(areaId: areaId)
        return try await apiClient.request(endpoint)
    }
    
    /// Get list of popular areas
    /// - Parameters:
    ///   - limit: Maximum number of areas to return
    ///   - days: Number of forecast days to include
    /// - Returns: Array of popular areas with request counts
    func getPopularAreas(limit: Int? = 50, days: Int? = nil) async throws -> [PopularArea] {
        let endpoint = ClimbingWeatherEndpoint.getPopularAreas(
            limit: limit,
            days: days,
            startDate: nil
        )
        return try await apiClient.request(endpoint)
    }
    
    /// Get areas marked for front page display
    /// - Parameter days: Number of forecast days to include
    /// - Returns: Array of front page areas
    func getFrontPageAreas(days: Int? = nil) async throws -> [Area] {
        let endpoint = ClimbingWeatherEndpoint.getFrontPageAreas(
            days: days,
            startDate: nil
        )
        return try await apiClient.request(endpoint)
    }
    
    /// List all areas in a country
    /// - Parameters:
    ///   - countryISO: ISO 3166 country code
    ///   - days: Number of forecast days to include
    /// - Returns: Array of areas
    func listAreasByCountry(countryISO: String, days: Int? = nil) async throws -> [Area] {
        let endpoint = ClimbingWeatherEndpoint.listAreasByCountry(
            countryISO: countryISO,
            startDate: nil,
            days: days,
            recent: nil
        )
        return try await apiClient.request(endpoint)
    }
    
    /// List areas in a specific administrative area (state/province)
    /// - Parameters:
    ///   - countryISO: ISO 3166 country code
    ///   - adminArea: Administrative area code
    ///   - days: Number of forecast days to include
    /// - Returns: Array of areas
    func listAreasByAdminArea(countryISO: String, adminArea: String, days: Int? = nil) async throws -> [Area] {
        let endpoint = ClimbingWeatherEndpoint.listAreasByAdminArea(
            countryISO: countryISO,
            adminArea: adminArea,
            days: days
        )
        return try await apiClient.request(endpoint)
    }
}
