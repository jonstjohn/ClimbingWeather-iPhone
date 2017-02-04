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

enum Symbol: String {
    case cloudy1
    case cloudy1_night
    case cloudy2
    case cloudy2_night
    case cloudy3
    case cloudy3_night
    case cloudy4
    case cloudy4_night
    case cloudy5
    case dunno
    case fog
    case fog_night
    case hail
    case light_rain
    case mist
    case mist_night
    case overcast
    case shower1
    case shower1_night
    case shower2
    case shower2_night
    case shower3
    case sleet
    case snow1
    case snow1_night
    case snow2
    case snow2_night
    case snow3
    case snow3_night
    case snow4
    case snow5
    case sunny
    case sunny_night
    case tstorm1
    case tstorm1_night
    case tstorm2
    case tstorm2_night
    case tstorm3

}

struct ForecastDay {
    let date: Date
    let day: String?
    let dateFormatted: String?
    let high: Int?
    let low: Int?
    let precipitation: Precipitation?
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
