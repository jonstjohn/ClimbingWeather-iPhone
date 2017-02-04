//
//  Forecast.swift
//  climbingweather
//
//  Created by Jon St. John on 2/3/17.
//
//

import Foundation

struct Precipitation {
    let rain: Decimal?
    let snow: Decimal?
}

struct Wind {
    let sustained: Int?
    let gust: Int?
}

enum Symbol {
    
}

struct ForecastDay {
    let date: Date
    let day: String?
    let dateFormatted: String?
    let high: Int?
    let low: Int?
    let precipiation: Precipitation?
    let precipitationChanceDay: Int?
    let precipitationChanceNight: Int?
    let symbol: Symbol?
    let humidity: Int?
    
}

struct ForecastHour {
    let day: String
    let time: Int
    let temperature: Int?
    let precipitationChance: Int?
    let humidity: Int?
    let rain: Decimal?
    let snow: Decimal?
    let wind: Wind?
    let weather: String
    let symbol: Symbol
    let conditions: String // formatted
}

struct ForecastDaily {
    let forecastDays: [ForecastDay]
}

struct ForecastHourly {
    let forecastHours: [ForecastHour]
}
