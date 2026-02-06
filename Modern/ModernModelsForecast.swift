//
//  Forecast.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Weather forecast in DarkSky-compatible format
struct Forecast: Codable, Hashable {
    /// Latitude (API returns as string, we store as double)
    let latitude: Double
    
    /// Longitude (API returns as string, we store as double)
    let longitude: Double
    
    /// IANA timezone identifier
    let timezone: String
    
    /// Area name
    let name: String
    
    /// Current weather conditions (typically null for NDFD)
    let currently: ForecastDataPoint?
    
    /// Minute-by-minute forecast (typically null for NDFD)
    let minutely: ForecastDataBlock?
    
    /// Hourly forecast
    let hourly: ForecastDataBlock?
    
    /// Daily forecast
    let daily: ForecastDataBlock?
    
    /// Weather alerts (typically null for NDFD)
    let alerts: [ForecastAlert]?
    
    /// Additional flags
    let flags: ForecastFlags?
    
    // Custom decoding to handle string lat/lon from API
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, timezone, name, currently, minutely, hourly, daily, alerts, flags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode latitude - handle both string and double
        if let latString = try? container.decode(String.self, forKey: .latitude),
           let lat = Double(latString) {
            self.latitude = lat
        } else {
            self.latitude = try container.decode(Double.self, forKey: .latitude)
        }
        
        // Decode longitude - handle both string and double
        if let lonString = try? container.decode(String.self, forKey: .longitude),
           let lon = Double(lonString) {
            self.longitude = lon
        } else {
            self.longitude = try container.decode(Double.self, forKey: .longitude)
        }
        
        self.timezone = try container.decode(String.self, forKey: .timezone)
        self.name = try container.decode(String.self, forKey: .name)
        self.currently = try container.decodeIfPresent(ForecastDataPoint.self, forKey: .currently)
        self.minutely = try container.decodeIfPresent(ForecastDataBlock.self, forKey: .minutely)
        self.hourly = try container.decodeIfPresent(ForecastDataBlock.self, forKey: .hourly)
        self.daily = try container.decodeIfPresent(ForecastDataBlock.self, forKey: .daily)
        self.alerts = try container.decodeIfPresent([ForecastAlert].self, forKey: .alerts)
        self.flags = try container.decodeIfPresent(ForecastFlags.self, forKey: .flags)
    }
    
    // For testing/mocking - keep the init
    init(latitude: Double, longitude: Double, timezone: String, name: String,
         currently: ForecastDataPoint?, minutely: ForecastDataBlock?,
         hourly: ForecastDataBlock?, daily: ForecastDataBlock?,
         alerts: [ForecastAlert]?, flags: ForecastFlags?) {
        self.latitude = latitude
        self.longitude = longitude
        self.timezone = timezone
        self.name = name
        self.currently = currently
        self.minutely = minutely
        self.hourly = hourly
        self.daily = daily
        self.alerts = alerts
        self.flags = flags
    }
}

/// A collection of forecast data points
struct ForecastDataBlock: Codable, Hashable {
    /// Human-readable summary
    let summary: String?
    
    /// Weather icon identifier
    let icon: String?
    
    /// Array of data points
    let data: [ForecastDataPoint]
}

/// A single forecast data point
struct ForecastDataPoint: Codable, Hashable, Identifiable {
    /// Unix timestamp
    let time: Int
    
    /// Weather summary
    let summary: String?
    
    /// Weather icon identifier
    let icon: String?
    
    /// Temperature (hourly)
    let temperature: Double?
    
    /// High temperature (daily)
    let temperatureHigh: Double?
    
    /// Low temperature (daily)
    let temperatureLow: Double?
    
    /// Precipitation probability (0-1)
    let precipProbability: Double?
    
    /// Night precipitation probability (0-1)
    let precipProbabilityNight: Double?
    
    /// Precipitation type
    let precipType: String?
    
    /// Precipitation accumulation (inches or cm)
    let precipAccumulation: Double?
    
    /// Cloud cover (0-1)
    let cloudCover: Double?
    
    /// Relative humidity (0-1)
    let humidity: Double?
    
    /// Wind speed (mph or m/s)
    let windSpeed: Double?
    
    /// Wind gust speed (mph or m/s)
    let windGust: Double?
    
    var id: Int { time }
    
    // Custom decoding to handle numeric values that might come as strings
    enum CodingKeys: String, CodingKey {
        case time, summary, icon, temperature, temperatureHigh, temperatureLow
        case precipProbability, precipProbabilityNight, precipType, precipAccumulation
        case cloudCover, humidity, windSpeed, windGust
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        time = try container.decode(Int.self, forKey: .time)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        
        // Decode numeric values - handle both string and double
        temperature = Self.decodeFlexibleDouble(from: container, forKey: .temperature)
        temperatureHigh = Self.decodeFlexibleDouble(from: container, forKey: .temperatureHigh)
        temperatureLow = Self.decodeFlexibleDouble(from: container, forKey: .temperatureLow)
        precipProbability = Self.decodeFlexibleDouble(from: container, forKey: .precipProbability)
        precipProbabilityNight = Self.decodeFlexibleDouble(from: container, forKey: .precipProbabilityNight)
        precipAccumulation = Self.decodeFlexibleDouble(from: container, forKey: .precipAccumulation)
        cloudCover = Self.decodeFlexibleDouble(from: container, forKey: .cloudCover)
        humidity = Self.decodeFlexibleDouble(from: container, forKey: .humidity)
        windSpeed = Self.decodeFlexibleDouble(from: container, forKey: .windSpeed)
        windGust = Self.decodeFlexibleDouble(from: container, forKey: .windGust)
        
        precipType = try container.decodeIfPresent(String.self, forKey: .precipType)
    }
    
    // Helper to decode doubles that might be strings
    private static func decodeFlexibleDouble(from container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) -> Double? {
        // Try as double first
        if let value = try? container.decodeIfPresent(Double.self, forKey: key) {
            return value
        }
        // Try as string and convert
        if let stringValue = try? container.decodeIfPresent(String.self, forKey: key),
           let doubleValue = Double(stringValue) {
            return doubleValue
        }
        return nil
    }
    
    // Keep init for testing/mocking
    init(time: Int, summary: String?, icon: String?, temperature: Double?,
         temperatureHigh: Double?, temperatureLow: Double?, precipProbability: Double?,
         precipProbabilityNight: Double?, precipType: String?, precipAccumulation: Double?,
         cloudCover: Double?, humidity: Double?, windSpeed: Double?, windGust: Double?) {
        self.time = time
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.temperatureHigh = temperatureHigh
        self.temperatureLow = temperatureLow
        self.precipProbability = precipProbability
        self.precipProbabilityNight = precipProbabilityNight
        self.precipType = precipType
        self.precipAccumulation = precipAccumulation
        self.cloudCover = cloudCover
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windGust = windGust
    }
    
    /// Date from Unix timestamp
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(time))
    }
    
    /// Precipitation probability as percentage
    var precipProbabilityPercentage: Int? {
        guard let precip = precipProbability else { return nil }
        return Int(precip * 100)
    }
    
    /// Night precipitation probability as percentage
    var precipProbabilityNightPercentage: Int? {
        guard let precip = precipProbabilityNight else { return nil }
        return Int(precip * 100)
    }
    
    /// Humidity as percentage
    var humidityPercentage: Int? {
        guard let humidity = humidity else { return nil }
        return Int(humidity * 100)
    }
    
    /// Cloud cover as percentage
    var cloudCoverPercentage: Int? {
        guard let cloudCover = cloudCover else { return nil }
        return Int(cloudCover * 100)
    }
}

/// A weather alert
struct ForecastAlert: Codable, Hashable, Identifiable {
    /// Alert title
    let title: String
    
    /// Alert issue time (Unix timestamp)
    let time: Int
    
    /// Alert expiration time (Unix timestamp)
    let expires: Int
    
    /// Detailed alert description
    let description: String
    
    /// Link to full alert details
    let uri: String
    
    var id: Int { time }
    
    /// Issue date
    var issueDate: Date {
        Date(timeIntervalSince1970: TimeInterval(time))
    }
    
    /// Expiration date
    var expirationDate: Date {
        Date(timeIntervalSince1970: TimeInterval(expires))
    }
}

/// Additional forecast flags
struct ForecastFlags: Codable, Hashable {
    /// Unit system (us or si)
    let units: String
}
