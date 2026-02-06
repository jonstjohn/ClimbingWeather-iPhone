//
//  ForecastView.swift
//  climbingweather
//
//  Created on 2/6/26.
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
                ProgressView("Loading forecast...")
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    viewModel.retry(areaId: areaId)
                }
            } else if let forecast = viewModel.forecast {
                ForecastContentView(forecast: forecast)
            } else {
                Text("No forecast data available")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle(areaName)
        .task {
            viewModel.loadForecast(areaId: areaId)
        }
        .refreshable {
            viewModel.loadForecast(areaId: areaId)
        }
    }
}

/// Content view displaying the forecast
struct ForecastContentView: View {
    let forecast: Forecast
    
    @SwiftUI.State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab selector
            Picker("Forecast Type", selection: $selectedTab) {
                Text("Daily").tag(0)
                Text("Hourly").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Content
            TabView(selection: $selectedTab) {
                DailyForecastList(dataPoints: forecast.daily?.data ?? [])
                    .tag(0)
                
                HourlyForecastList(dataPoints: forecast.hourly?.data ?? [])
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

/// Daily forecast list
struct DailyForecastList: View {
    let dataPoints: [ForecastDataPoint]
    
    var body: some View {
        List(dataPoints) { dataPoint in
            DailyForecastRow(dataPoint: dataPoint)
        }
        .listStyle(.plain)
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
            
            // Summary
            if let summary = dataPoint.summary {
                Text(summary)
                    .font(.subheadline)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Temperature
            VStack(alignment: .trailing, spacing: 4) {
                if let high = dataPoint.temperatureHigh {
                    Text("\(Int(high))°")
                        .font(.headline)
                }
                if let low = dataPoint.temperatureLow {
                    Text("\(Int(low))°")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Precipitation
            if let precip = dataPoint.precipProbabilityPercentage, precip > 0 {
                VStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Text("\(precip)%")
                        .font(.caption2)
                }
                .frame(width: 40)
            }
        }
        .padding(.vertical, 8)
    }
}

/// Hourly forecast list
struct HourlyForecastList: View {
    let dataPoints: [ForecastDataPoint]
    
    var body: some View {
        List(dataPoints) { dataPoint in
            HourlyForecastRow(dataPoint: dataPoint)
        }
        .listStyle(.plain)
    }
}

/// Single hourly forecast row
struct HourlyForecastRow: View {
    let dataPoint: ForecastDataPoint
    
    var body: some View {
        HStack(spacing: 16) {
            // Time
            Text(dataPoint.date, format: .dateTime.hour().minute())
                .font(.headline)
                .frame(width: 80, alignment: .leading)
            
            // Icon
            if let icon = dataPoint.icon {
                WeatherIconView(icon: icon)
                    .frame(width: 30, height: 30)
            }
            
            // Temperature
            if let temp = dataPoint.temperature {
                Text("\(Int(temp))°")
                    .font(.headline)
                    .frame(width: 50)
            }
            
            Spacer()
            
            // Precipitation
            if let precip = dataPoint.precipProbabilityPercentage {
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Text("\(precip)%")
                        .font(.subheadline)
                }
                .frame(width: 60)
            }
            
            // Wind
            if let windSpeed = dataPoint.windSpeed {
                HStack(spacing: 4) {
                    Image(systemName: "wind")
                        .foregroundColor(.gray)
                    Text("\(Int(windSpeed)) mph")
                        .font(.subheadline)
                }
            }
        }
        .padding(.vertical, 4)
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
            areaId: 123,
            areaName: "Yosemite Valley",
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
            name: "Yosemite Valley",
            currently: nil,
            minutely: nil,
            hourly: nil,
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
