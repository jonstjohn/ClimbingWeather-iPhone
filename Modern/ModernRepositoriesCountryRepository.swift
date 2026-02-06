//
//  CountryRepository.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Protocol for country and administrative area operations
protocol CountryRepositoryProtocol {
    func listCountries() async throws -> [Country]
    func listAdminAreas(countryISO: String, includeAreas: Bool, days: Int?) async throws -> [AdminArea]
    func getAdminAreaBounds(adminArea: String) async throws -> AdminAreaBounds
}

/// Repository for country and administrative area operations
final class CountryRepository: CountryRepositoryProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    /// Get list of all countries
    /// - Returns: Array of countries
    func listCountries() async throws -> [Country] {
        let endpoint = ClimbingWeatherEndpoint.listCountries
        return try await apiClient.request(endpoint)
    }
    
    /// Get administrative areas (states/provinces) within a country
    /// - Parameters:
    ///   - countryISO: ISO 3166 country code
    ///   - includeAreas: Whether to include climbing areas in the response
    ///   - days: Number of forecast days to include (requires includeAreas=true)
    /// - Returns: Array of administrative areas
    func listAdminAreas(
        countryISO: String,
        includeAreas: Bool = false,
        days: Int? = nil
    ) async throws -> [AdminArea] {
        let endpoint = ClimbingWeatherEndpoint.listAdminAreas(
            countryISO: countryISO,
            includeAreas: includeAreas,
            frontPage: nil,
            days: days,
            startDate: nil
        )
        return try await apiClient.request(endpoint)
    }
    
    /// Get geographic boundaries for an administrative area
    /// - Parameter adminArea: Administrative area code (e.g., state code)
    /// - Returns: Administrative area with boundary coordinates
    func getAdminAreaBounds(adminArea: String) async throws -> AdminAreaBounds {
        let endpoint = ClimbingWeatherEndpoint.getAdminAreaBounds(adminArea: adminArea)
        return try await apiClient.request(endpoint)
    }
}
