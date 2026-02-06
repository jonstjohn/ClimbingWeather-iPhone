//
//  AreaListViewModel.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation
import Combine

/// ViewModel for displaying lists of areas (popular, front page, by state, etc.)
@MainActor
final class AreaListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var areas: [Area] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    
    private let repository: AreaRepositoryProtocol
    private var loadTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    
    var hasResults: Bool {
        !areas.isEmpty
    }
    
    var hasError: Bool {
        error != nil
    }
    
    // MARK: - Initialization
    
    init(repository: AreaRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    /// Load popular areas
    /// - Parameters:
    ///   - limit: Maximum number of areas
    ///   - days: Number of forecast days to include
    func loadPopularAreas(limit: Int = 50, days: Int? = nil) {
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            error = nil
            
            do {
                let popularAreas = try await repository.getPopularAreas(limit: limit, days: days)
                // Convert PopularArea to Area (they have the same structure minus requestCount)
                areas = popularAreas.map { popular in
                    Area(
                        areaId: popular.areaId,
                        country: popular.country,
                        adminArea: popular.adminArea,
                        adminAreaName: popular.adminAreaName ?? "", // Handle nil case
                        name: popular.name,
                        latitude: popular.latitude,
                        longitude: popular.longitude,
                        forecast: popular.forecast
                    )
                }
            } catch {
                if !Task.isCancelled {
                    self.error = error
                    print("❌ Failed to load popular areas: \(error.localizedDescription)")
                }
            }
            
            isLoading = false
        }
    }
    
    /// Load front page areas
    /// - Parameter days: Number of forecast days to include
    func loadFrontPageAreas(days: Int? = nil) {
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            error = nil
            
            do {
                areas = try await repository.getFrontPageAreas(days: days)
            } catch {
                if !Task.isCancelled {
                    self.error = error
                    print("❌ Failed to load front page areas: \(error.localizedDescription)")
                }
            }
            
            isLoading = false
        }
    }
    
    /// Load areas by administrative area (state/province)
    /// - Parameters:
    ///   - countryISO: ISO country code
    ///   - adminArea: Administrative area code
    ///   - days: Number of forecast days to include
    func loadAreasByAdminArea(countryISO: String, adminArea: String, days: Int? = nil) {
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            error = nil
            
            do {
                areas = try await repository.listAreasByAdminArea(
                    countryISO: countryISO,
                    adminArea: adminArea,
                    days: days
                )
            } catch {
                if !Task.isCancelled {
                    self.error = error
                    print("❌ Failed to load areas: \(error.localizedDescription)")
                }
            }
            
            isLoading = false
        }
    }
    
    /// Load areas by country
    /// - Parameters:
    ///   - countryISO: ISO country code
    ///   - days: Number of forecast days to include
    func loadAreasByCountry(countryISO: String, days: Int? = nil) {
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            error = nil
            
            do {
                areas = try await repository.listAreasByCountry(countryISO: countryISO, days: days)
            } catch {
                if !Task.isCancelled {
                    self.error = error
                    print("❌ Failed to load areas: \(error.localizedDescription)")
                }
            }
            
            isLoading = false
        }
    }
    
    /// Retry the last load operation
    func retry() {
        // Note: This is a simplified retry. In production, you'd want to store
        // the last operation type and parameters to properly retry
        error = nil
    }
    
    /// Clear all data
    func clear() {
        loadTask?.cancel()
        areas = []
        error = nil
        isLoading = false
    }
    
    // MARK: - Deinitializer
    
    deinit {
        loadTask?.cancel()
    }
}
