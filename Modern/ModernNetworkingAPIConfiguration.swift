//
//  APIConfiguration.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Configuration for the API client
struct APIConfiguration {
    let baseURL: URL
    let apiKey: String
    let defaultTempUnit: String
    let timeout: TimeInterval
    
    /// Production configuration
    static func production(apiKey: String) -> APIConfiguration {
        return APIConfiguration(
            baseURL: URL(string: "https://api.climbingweather.com")!,
            apiKey: apiKey,
            defaultTempUnit: "f",
            timeout: 30.0
        )
    }
    
    /// Staging configuration
    static func staging(apiKey: String) -> APIConfiguration {
        return APIConfiguration(
            baseURL: URL(string: "https://api-dev.climbingweather.com")!,
            apiKey: apiKey,
            defaultTempUnit: "f",
            timeout: 30.0
        )
    }
    
    /// Local development configuration
    static func local(apiKey: String) -> APIConfiguration {
        return APIConfiguration(
            baseURL: URL(string: "http://localhost:8000")!,
            apiKey: apiKey,
            defaultTempUnit: "f",
            timeout: 30.0
        )
    }
}
