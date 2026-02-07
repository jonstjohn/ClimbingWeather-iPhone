//
//  ForecastView.swift
//  climbingweather
//
//  Created on 2/6/26.
//  Redesigned with 4-section scrolling layout
//

import SwiftUI

/// Main forecast view for an area
struct ForecastView: View {
    
    @StateObject private var viewModel: AreaForecastViewModel
    
    let areaId: Int
    let areaName: String
    
    init(areaId: Int, areaName: String, repository: AreaRepositoryProtocol) {
        self.areaId = areaId
        self.areaName = areaName
        _viewModel = StateObject(wrappedValue: AreaForecastViewModel(repository: repository))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView("Loading forecast...")
                    Spacer()
                }
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    viewModel.retry(areaId: areaId)
                }
            } else if let forecast = viewModel.forecast {
                ForecastContentView(forecast: forecast)
            } else {
                VStack {
                    Spacer()
                    Text("No forecast data available")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .navigationTitle(areaName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.loadForecast(areaId: areaId)
        }
        .refreshable {
            viewModel.loadForecast(areaId: areaId)
        }
    }
}

/// Content view with 4-section scrolling layout
struct ForecastContentView: View {
    let forecast: Forecast
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Section 1: Current Conditions (1/3 of screen)
                CurrentConditionsSection(forecast: forecast)
                
                // Section 2: Hourly Forecast (horizontal scroll)
                HourlyForecastSection(dataPoints: forecast.hourly?.data ?? [])
                
                // Section 3: Daily Forecast (7 days)
                DailyForecastSection(dataPoints: forecast.daily?.data ?? [])
            }
        }
    }
}

/// Section 1: Current conditions with large temperature and icon (~1/3 screen)
struct CurrentConditionsSection: View {
    let forecast: Forecast
    
    var currentConditions: ForecastDataPoint? {
        forecast.hourly?.data.first
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 16) {
                    if let current = currentConditions {
                        // Weather icon
                        if let icon = current.icon {
                            WeatherIconView(icon: icon)
                                .frame(width: 80, height: 80)
                        }
                        
                        // Current temperature - BIG
                        if let temp = current.temperature {
                            Text("\(Int(temp))°")
                                .font(.system(size: 72, weight: .thin))
                        }
                        
                        // Conditions summary
                        if let summary = current.summary {
                            Text(summary)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        // Additional details row
                        HStack(spacing: 32) {
                            if let precip = current.precipProbabilityPercentage, precip > 0 {
                                VStack(spacing: 4) {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.blue)
                                    Text("\(precip)%")
                                        .font(.caption)
                                }
                            }
                            
                            if let humidity = current.humidityPercentage {
                                VStack(spacing: 4) {
                                    Image(systemName: "humidity.fill")
                                        .foregroundColor(.cyan)
                                    Text("\(humidity)%")
                                        .font(.caption)
                                }
                            }
                            
                            if let windSpeed = current.windSpeed {
                                VStack(spacing: 4) {
                                    Image(systemName: "wind")
                                        .foregroundColor(.gray)
                                    Text("\(Int(windSpeed)) mph")
                                        .font(.caption)
                                }
                            }
                        }
                    } else {
                        Text("Current conditions unavailable")
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.33) // 1/3 of screen
    }
}

/// Section 2: Horizontally scrolling hourly forecast
struct HourlyForecastSection: View {
    let dataPoints: [ForecastDataPoint]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hourly Forecast")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(dataPoints.prefix(24)) { dataPoint in // First 24 hours
                        HourlyForecastCard(dataPoint: dataPoint)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            
            Divider()
                .padding(.top, 8)
        }
        .background(Color(UIColor.systemBackground))
    }
}

/// Individual hourly forecast card
struct HourlyForecastCard: View {
    let dataPoint: ForecastDataPoint
    
    var body: some View {
        VStack(spacing: 8) {
            // Time
            Text(dataPoint.date, format: .dateTime.hour())
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Icon
            if let icon = dataPoint.icon {
                WeatherIconView(icon: icon)
                    .frame(width: 32, height: 32)
            }
            
            // Temperature
            if let temp = dataPoint.temperature {
                Text("\(Int(temp))°")
                    .font(.headline)
            }
            
            // Precipitation
            if let precip = dataPoint.precipProbabilityPercentage, precip > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "drop.fill")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    Text("\(precip)%")
                        .font(.caption2)
                }
            } else {
                Text(" ")
                    .font(.caption2)
            }
        }
        .frame(width: 70)
        .padding(.vertical, 12)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

/// Section 3: Daily forecast list (7 days)
struct DailyForecastSection: View {
    let dataPoints: [ForecastDataPoint]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("7-Day Forecast")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            ForEach(dataPoints) { dataPoint in
                DailyForecastRow(dataPoint: dataPoint)
                
                if dataPoint.id != dataPoints.last?.id {
                    Divider()
                        .padding(.horizontal)
                }
            }
            
            // Bottom padding
            Color.clear.frame(height: 20)
        }
        .background(Color(UIColor.systemBackground))
    }
}

/// Single daily forecast row
struct DailyForecastRow: View {
    let dataPoint: ForecastDataPoint
    
    var body: some View {
        HStack(spacing: 16) {
            // Date
            VStack(alignment: .leading, spacing: 4) {
                Text(dataPoint.date, format: .dateTime.weekday(.abbreviated))
                    .font(.headline)
                Text(dataPoint.date, format: .dateTime.month().day())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, alignment: .leading)
            
            // Icon
            if let icon = dataPoint.icon {
                WeatherIconView(icon: icon)
                    .frame(width: 40, height: 40)
            }
            
            Spacer()
            
            // Precipitation
            if let precip = dataPoint.precipProbabilityPercentage, precip > 0 {
                VStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("\(precip)%")
                        .font(.caption2)
                }
                .frame(width: 40)
            }
            
            // Temperature range
            HStack(spacing: 8) {
                if let low = dataPoint.temperatureLow {
                    Text("\(Int(low))°")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let high = dataPoint.temperatureHigh {
                    Text("\(Int(high))°")
                        .font(.headline)
                }
            }
            .frame(width: 70, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

/// Simple weather icon view (you'd replace this with your actual icon logic)
struct WeatherIconView: View {
    let icon: String
    
    var body: some View {
        Image(systemName: symbolName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(iconColor)
    }
    
    private var symbolName: String {
        switch icon {
        case "clear-day", "sunny":
            return "sun.max.fill"
        case "clear-night", "sunny_night":
            return "moon.stars.fill"
        case "rain", "light_rain":
            return "cloud.rain.fill"
        case "snow", "snow1", "snow2":
            return "cloud.snow.fill"
        case "cloudy", "cloudy1", "cloudy2":
            return "cloud.fill"
        case "partly-cloudy-day", "cloudy3":
            return "cloud.sun.fill"
        case "partly-cloudy-night", "cloudy3_night":
            return "cloud.moon.fill"
        case "wind":
            return "wind"
        case "fog":
            return "cloud.fog.fill"
        default:
            return "cloud.fill"
        }
    }
    
    private var iconColor: Color {
        switch icon {
        case "clear-day", "sunny":
            return .yellow
        case "clear-night", "sunny_night":
            return .purple
        case "rain", "light_rain":
            return .blue
        case "snow", "snow1", "snow2":
            return .cyan
        default:
            return .gray
        }
    }
}

/// Error view with retry button
struct ErrorView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: retry) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ForecastView(
            areaId: 518,
            areaName: "Yosemite National Park",
            repository: MockAreaRepository()
        )
    }
}

// Mock repository for previews
final class MockAreaRepository: AreaRepositoryProtocol {
    func searchAreas(query: String) async throws -> [Area] { [] }
    func getForecast(areaId: Int, days: Int, tempUnit: String?) async throws -> Forecast {
        Forecast(
            latitude: 37.7456,
            longitude: -119.5937,
            timezone: "America/Los_Angeles",
            name: "Yosemite National Park",
            currently: nil,
            minutely: nil,
            hourly: ForecastDataBlock(
                summary: nil,
                icon: nil,
                data: [
                    ForecastDataPoint(
                        time: Int(Date().timeIntervalSince1970),
                        summary: "Clear",
                        icon: "clear-day",
                        temperature: 65,
                        temperatureHigh: nil,
                        temperatureLow: nil,
                        precipProbability: 0.1,
                        precipProbabilityNight: nil,
                        precipType: nil,
                        precipAccumulation: nil,
                        cloudCover: 0.2,
                        humidity: 0.5,
                        windSpeed: 5,
                        windGust: 10
                    )
                ]
            ),
            daily: ForecastDataBlock(
                summary: "Clear skies",
                icon: "clear-day",
                data: [
                    ForecastDataPoint(
                        time: Int(Date().timeIntervalSince1970),
                        summary: "Clear",
                        icon: "clear-day",
                        temperature: nil,
                        temperatureHigh: 75,
                        temperatureLow: 45,
                        precipProbability: 0.1,
                        precipProbabilityNight: nil,
                        precipType: nil,
                        precipAccumulation: nil,
                        cloudCover: 0.2,
                        humidity: 0.5,
                        windSpeed: 5,
                        windGust: 10
                    )
                ]
            ),
            alerts: nil,
            flags: nil
        )
    }
    func getAreaDetail(areaId: Int, includeClimateStation: Bool) async throws -> AreaDetail {
        fatalError("Not implemented")
    }
    func getAreaAverages(areaId: Int) async throws -> AreaAverages {
        fatalError("Not implemented")
    }
    func getPopularAreas(limit: Int?, days: Int?) async throws -> [PopularArea] { [] }
    func getFrontPageAreas(days: Int?) async throws -> [Area] { [] }
    func listAreasByCountry(countryISO: String, days: Int?) async throws -> [Area] { [] }
    func listAreasByAdminArea(countryISO: String, adminArea: String, days: Int?) async throws -> [Area] { [] }
}
