//
//  ForecastView.swift
//  climbingweather
//
//  Created on 2/6/26.
//  Redesigned with 4-section scrolling layout
//

import SwiftUI

/// Main forecast view for an area
struct ModernForecastView: View {
    
    @StateObject private var viewModel: AreaForecastViewModel
    
    let areaId: Int
    let areaName: String
    let repository: AreaRepositoryProtocol
    
    init(areaId: Int, areaName: String, repository: AreaRepositoryProtocol) {
        self.areaId = areaId
        self.areaName = areaName
        self.repository = repository
        _viewModel = StateObject(wrappedValue: AreaForecastViewModel(repository: repository))
    }
    
    @SwiftUI.State private var showingSearch = false
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView("Loading forecast...")
                    Spacer()
                }
            } else if let error = viewModel.error {
                ModernForecastErrorView(error: error) {
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSearch = true
                } label: {
                    Label("Search Areas", systemImage: "magnifyingglass")
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            AreaSearchView(repository: repository)
        }
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
                HourlyForecastSection(
                    dataPoints: forecast.hourly?.data ?? [],
                    timezone: TimeZone(identifier: forecast.timezone) ?? .current
                )
                
                // Section 3: Daily Forecast (7 days)
                DailyForecastSection(
                    dataPoints: forecast.daily?.data ?? [],
                    timezone: TimeZone(identifier: forecast.timezone) ?? .current
                )
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
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    if let current = currentConditions {
                        VStack(spacing: 4) {
                            // Temperature and icon row
                            HStack(alignment: .center, spacing: 20) {
                                // Weather icon - smaller, on the left
                                if let icon = current.icon {
                                    WeatherIconView(icon: icon)
                                        .frame(width: 40, height: 40)
                                }
                                
                                // Current temperature - BIG
                                if let temp = current.temperature {
                                    Text("\(Int(temp))°")
                                        .font(.system(size: 72, weight: .thin))
                                }
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
                        }
                    } else {
                        Text("Current conditions unavailable")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.25) // 1/4 of screen
    }
}

/// Section 2: Horizontally scrolling hourly forecast
struct HourlyForecastSection: View {
    let dataPoints: [ForecastDataPoint]
    let timezone: TimeZone
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hourly Forecast")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(dataPoints.prefix(48).enumerated()), id: \.element.id) { index, dataPoint in
                        HourlyForecastCardWithDay(
                            dataPoint: dataPoint,
                            timezone: timezone,
                            showDayLabel: shouldShowDayLabel(for: dataPoint, at: index, in: Array(dataPoints.prefix(48)))
                        )
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
    
    /// Determine if we should show a day label for this hour
    private func shouldShowDayLabel(for dataPoint: ForecastDataPoint, at index: Int, in dataPoints: [ForecastDataPoint]) -> Bool {
        // Always show for the first item
        if index == 0 {
            return true
        }
        
        // Show if the day changed from the previous hour
        let previousDataPoint = dataPoints[index - 1]
        var calendar = Calendar.current
        calendar.timeZone = timezone
        let currentDay = calendar.component(.day, from: dataPoint.date)
        let previousDay = calendar.component(.day, from: previousDataPoint.date)
        
        return currentDay != previousDay
    }
}

/// Individual hourly forecast card with optional day label
struct HourlyForecastCardWithDay: View {
    let dataPoint: ForecastDataPoint
    let timezone: TimeZone
    let showDayLabel: Bool
    
    // Create timezone-aware formatted strings
    private var hourText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        formatter.timeZone = timezone
        return formatter.string(from: dataPoint.date)
    }
    
    private var weekdayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.timeZone = timezone
        return formatter.string(from: dataPoint.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Day label or spacer to keep alignment
            Group {
                if showDayLabel {
                    Text(weekdayText)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.leading, 8)
                } else {
                    // Empty spacer with same height as day label
                    Text(" ")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .opacity(0)
                }
            }
            
            // The card itself
            VStack(spacing: 8) {
                // Time
                Text(hourText)
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
    let timezone: TimeZone
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("7-Day Forecast")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            ForEach(dataPoints) { dataPoint in
                DailyForecastRow(dataPoint: dataPoint, timezone: timezone)
                
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
    let timezone: TimeZone
    
    // Create timezone-aware formatted strings
    private var weekdayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.timeZone = timezone
        return formatter.string(from: dataPoint.date)
    }
    
    private var monthDayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        formatter.timeZone = timezone
        return formatter.string(from: dataPoint.date)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Date
            VStack(alignment: .leading, spacing: 4) {
                Text(weekdayText)
                    .font(.headline)
                Text(monthDayText)
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

/// Weather icon view with API code mapping
struct WeatherIconView: View {
    let icon: String
    
    var body: some View {
        let mappedIconName = mapAPIIconToAssetName(icon)
        let _ = debugIconMapping(apiIcon: icon, mappedIcon: mappedIconName)
        
        // Use the project's bundled weather icon images
        if let uiImage = UIImage(named: mappedIconName) {
            let _ = print("   ✅ Loaded asset: '\(mappedIconName)'")
            return AnyView(
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            )
        } else {
            let fallback = fallbackSymbolName(for: mappedIconName)
            let _ = print("   ⚠️ Asset NOT found, using SF Symbol: '\(fallback)'")
            // Fallback to SF Symbol if icon asset not found
            return AnyView(
                Image(systemName: fallback)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            )
        }
    }
    
    /// Debug helper for icon mapping
    private func debugIconMapping(apiIcon: String, mappedIcon: String) {
        print("🔍 Icon Debug:")
        print("   API Code: '\(apiIcon)'")
        print("   Mapped To: '\(mappedIcon)'")
    }
    
    /// Map API icon codes to local asset names
    /// Supports codes with file extensions (e.g., "few.jpg") and trailing digits (e.g., "sn80")
    private func mapAPIIconToAssetName(_ apiIcon: String) -> String {
        // Strip file extensions (.jpg, .png, etc.) from API icon codes
        var cleanIcon = apiIcon.replacingOccurrences(of: ".jpg", with: "")
                                .replacingOccurrences(of: ".png", with: "")
                                .replacingOccurrences(of: ".gif", with: "")
        
        // Strip trailing digits (e.g., "sn80" → "sn", "ra50" → "ra")
        cleanIcon = cleanIcon.replacingOccurrences(of: #"\d+$"#, with: "", options: .regularExpression)
        
        switch cleanIcon {
        // === DarkSky-style codes (common format) ===
        case "clear-day": return "sunny"
        case "clear-night": return "sunny_night"
        case "partly-cloudy-day": return "cloudy2"
        case "partly-cloudy-night": return "cloudy2_night"
        case "cloudy": return "overcast"
        case "rain": return "shower3"
        case "sleet": return "sleet"
        case "snow": return "snow4"
        case "wind": return "cloudy1"
        case "fog": return "fog"
        case "thunderstorm": return "tstorm3"
        
        // === NOAA/NDFD codes ===
        // Clear/Fair
        case "skc": return "sunny"
        case "nskc": return "sunny_night"
        
        // Few clouds
        case "few": return "cloudy1"
        case "nfew": return "cloudy1_night"
        
        // Scattered clouds
        case "sct": return "cloudy2"
        case "nsct": return "cloudy2_night"
        
        // Broken clouds
        case "bkn": return "cloudy3"
        case "nbkn": return "cloudy3_night"
        
        // Overcast
        case "ovc", "novc": return "overcast"
        
        // Fog/Mist
        case "fg": return "fog"
        case "nfg": return "fog_night"
        case "smoke": return "fog"
        case "mist": return "mist"
        
        // Light rain
        case "ra1", "nra": return "light_rain"
        
        // Rain/Showers
        case "ra", "shra": return "shower3"
        case "hi_shwrs": return "shower1"
        case "hi_nshwrs": return "shower2"
        
        // Freezing rain/Sleet
        case "fzra", "mix", "nmix", "raip", "rasn", "nrasn", "fzrara": return "sleet"
        
        // Hail
        case "ip": return "hail"
        
        // Snow
        case "sn", "nsn": return "snow4"
        
        // Thunderstorms - light
        case "hi_tsra": return "tstorm1"
        case "hi_ntsra": return "tstorm1_night"
        
        // Thunderstorms - moderate
        case "scttsra": return "tstorm2"
        case "nscttsra": return "tstorm2_night"
        
        // Thunderstorms - heavy
        case "tsra", "ntsra": return "tstorm3"
        
        // Wind
        case "wind": return "cloudy1"
        case "nwind": return "cloudy1_night"
        
        // Severe/Dust/Unknown
        case "nsvrtsra", "dust": return "cloudy1"
        case "dunno": return "dunno"
        
        // If already a local asset name, use it directly
        default: return apiIcon
        }
    }
    
    // Fallback SF Symbols for missing icons
    private func fallbackSymbolName(for iconName: String) -> String {
        switch iconName {
        case "sunny": return "sun.max.fill"
        case "sunny_night": return "moon.stars.fill"
        case "light_rain", "shower1", "shower2", "shower3": return "cloud.rain.fill"
        case "snow1", "snow2", "snow3", "snow4", "snow5": return "cloud.snow.fill"
        case "cloudy1", "cloudy2", "cloudy3", "cloudy4", "cloudy5", "overcast": return "cloud.fill"
        case "fog", "mist", "fog_night", "mist_night": return "cloud.fog.fill"
        case "tstorm1", "tstorm2", "tstorm3": return "cloud.bolt.rain.fill"
        case "sleet", "hail": return "cloud.sleet.fill"
        default: return "cloud.fill"
        }
    }
}

/// Error view with retry button
struct ModernForecastErrorView: View {
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
        ModernForecastView(
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
