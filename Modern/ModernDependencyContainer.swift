//
//  DependencyContainer.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Centralized dependency container for the modern architecture
final class DependencyContainer {
    
    // MARK: - Shared Instance
    
    static let shared = DependencyContainer()
    
    // MARK: - Configuration
    
    private let configuration: APIConfiguration
    
    // MARK: - Networking
    
    lazy var apiClient: APIClientProtocol = {
        APIClient(configuration: configuration)
    }()
    
    // MARK: - Repositories
    
    lazy var areaRepository: AreaRepositoryProtocol = {
        AreaRepository(apiClient: apiClient)
    }()
    
    lazy var countryRepository: CountryRepositoryProtocol = {
        CountryRepository(apiClient: apiClient)
    }()
    
    lazy var climateRepository: ClimateRepositoryProtocol = {
        ClimateRepository(apiClient: apiClient)
    }()
    
    // MARK: - Initialization
    
    private init() {
        // Load API key from preferences or configuration
        let apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? "iphone-VALID"
        
        #if DEBUG
        // Use staging for debug builds
        self.configuration = .staging(apiKey: apiKey)
        #else
        // Use production for release builds
        self.configuration = .production(apiKey: apiKey)
        #endif
    }
    
    // MARK: - Custom Initialization (for testing)
    
    /// Create a custom container with specific configuration
    /// - Parameter configuration: API configuration
    /// - Returns: Configured dependency container
    static func custom(configuration: APIConfiguration) -> DependencyContainer {
        let container = DependencyContainer.__internal_init(configuration: configuration)
        return container
    }
    
    private init(configuration: APIConfiguration) {
        self.configuration = configuration
    }
    
    private static func __internal_init(configuration: APIConfiguration) -> DependencyContainer {
        return DependencyContainer(configuration: configuration)
    }
}

// MARK: - Convenience Accessors

extension DependencyContainer {
    
    /// Get a configured AreaSearchViewModel
    @MainActor
    func makeAreaSearchViewModel() -> AreaSearchViewModel {
        AreaSearchViewModel(repository: areaRepository)
    }
    
    /// Get a configured AreaForecastViewModel
    @MainActor
    func makeAreaForecastViewModel(tempUnit: String = "f") -> AreaForecastViewModel {
        AreaForecastViewModel(repository: areaRepository, tempUnit: tempUnit)
    }
    
    /// Get a configured AreaListViewModel
    @MainActor
    func makeAreaListViewModel() -> AreaListViewModel {
        AreaListViewModel(repository: areaRepository)
    }
}
