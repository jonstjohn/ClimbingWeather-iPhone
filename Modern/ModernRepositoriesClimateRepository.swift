//
//  ClimateRepository.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Protocol for climate station operations
protocol ClimateRepositoryProtocol {
    func getStationDetail(stationId: Int) async throws -> Clim81Station
}

/// Repository for climate station operations
final class ClimateRepository: ClimateRepositoryProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    /// Get details for a NOAA 1981-2010 Climate Normals station
    /// - Parameter stationId: Climate station identifier
    /// - Returns: Climate station details with monthly averages
    func getStationDetail(stationId: Int) async throws -> Clim81Station {
        let endpoint = ClimbingWeatherEndpoint.getClim81StationDetail(stationId: stationId)
        return try await apiClient.request(endpoint)
    }
}
