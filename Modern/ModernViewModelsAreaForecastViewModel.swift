//
//  AreaForecastViewModel.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation
import Combine

/// ViewModel for area forecast display
@MainActor
final class AreaForecastViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var forecast: Forecast?
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    
    private let repository: AreaRepositoryProtocol
    private let tempUnit: String
    private var loadTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    
    var dailyForecasts: [ForecastDataPoint] {
        forecast?.daily?.data ?? []
    }
    
    var hourlyForecasts: [ForecastDataPoint] {
        forecast?.hourly?.data ?? []
    }
    
    var alerts: [ForecastAlert] {
        forecast?.alerts ?? []
    }
    
    var hasError: Bool {
        error != nil
    }
    
    // MARK: - Initialization
    
    init(repository: AreaRepositoryProtocol, tempUnit: String = "f") {
        self.repository = repository
        self.tempUnit = tempUnit
    }
    
    // MARK: - Public Methods
    
    /// Load forecast for an area
    /// - Parameters:
    ///   - areaId: Area identifier
    ///   - days: Number of forecast days (default: 7)
    func loadForecast(areaId: Int, days: Int = 7) {
        // Cancel any existing load task
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            error = nil
            
            do {
                forecast = try await repository.getForecast(
                    areaId: areaId,
                    days: days,
                    tempUnit: tempUnit
                )
            } catch {
                // Only set error if the task wasn't cancelled
                if !Task.isCancelled {
                    self.error = error
                    print("❌ Failed to load forecast: \(error.localizedDescription)")
                }
            }
            
            isLoading = false
        }
    }
    
    /// Retry loading the forecast
    func retry(areaId: Int, days: Int = 7) {
        loadForecast(areaId: areaId, days: days)
    }
    
    /// Clear the current forecast and error state
    func clear() {
        loadTask?.cancel()
        forecast = nil
        error = nil
        isLoading = false
    }
    
    // MARK: - Deinitializer
    
    deinit {
        loadTask?.cancel()
    }
}
