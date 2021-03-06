//
//  Forecast.swift
//  climbingweather
//
//  Created by Jon St. John on 2/3/17.
//
//

import Foundation
import UIKit

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
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }

}

public struct ForecastDay {
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
    let conditions: String?
    let conditionsFormatted: String?
    let wind: Wind?
    
    var highFormatted: String {
        guard let high = self.high else {
            return "-"
        }
        return String(format: "%d˚", high)
    }
    
    var lowFormatted: String {
        guard let low = self.low else {
            return "-"
        }
        return String(format: "%d˚", low)
    }
    
    var precipitationChanceDayFormatted: String {
        guard let precip = self.precipitationChanceDay else {
            return "-"
        }
        return String(format: "%d%%", precip)
    }
    
    var precipitationChanceNightFormatted: String {
        guard let precip = self.precipitationChanceNight else {
            return "-"
        }
        return String(format: "%d%%", precip)
    }
    
    var windSustainedFormatted: String {
        guard let wind = self.wind?.sustained else {
            return "-"
        }
        return String(format: "%d mph", wind)
    }
    
    var humidityFormatted: String {
        guard let humidity = self.humidity else {
            return "-"
        }
        return String(format: "%d%%", humidity)
    }
    
    static func parseDaily(dailies: [[String: Any]]?) -> [ForecastDay]? {
        
        guard let dailies = dailies else {
            return nil
        }
        
        var forecasts = [ForecastDay]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for daily in dailies {
            if let dateStr = daily["d"] as? String, let date = dateFormatter.date(from: dateStr) {
                
                let day = daily["dy"] as? String // day
                let dateFormatted = daily["dd"] as? String // formatted date
                
                let high = self.asInt(daily["hi"]) // high
                let low = self.asInt(daily["l"]) // low
                
                // Precipitation amount
                let precipitation = Precipitation(
                    rain: self.asDecimal(daily["r"]),
                    snow: self.asDecimal(daily["s"])
                )
                
                let precipChanceDay = self.asInt(daily["pd"]) // precip change day
                let precipChanceNight = self.asInt(daily["pn"]) // precip change night
                
                // Symbol
                var symbol: Symbol?
                if let sym = daily["sy"] as? String {
                    symbol = Symbol(rawValue: sym)
                }
                
                let conditions = daily["w"] as? String // conditions
                let conditionsFormatted = daily["c"] as? String // conditions formatted
                
                let humidity = self.asInt(daily["h"]) // humidity

                
                // Wind
                let wind = Wind(
                    sustained: self.asInt(daily["ws"]),
                    gust: self.asInt(daily["wg"])
                )
                
                let forecast = ForecastDay(
                    date: date, day: day, dateFormatted: dateFormatted,
                    high: high, low: low, precipitation: precipitation,
                    precipitationChanceDay: precipChanceDay, precipitationChanceNight: precipChanceNight,
                    symbol: symbol, humidity: humidity, conditions: conditions, conditionsFormatted: conditionsFormatted,
                    wind: wind)
                forecasts.append(forecast)
            }
        }
        return forecasts
    }
    
    static private func asInt(_ value: Any?) -> Int? {
        if let ret = value as? String {
            return Int(ret)
        }
        
        if let ret = value as? Int {
            return ret
        }
        
        return nil
    }
    
    static private func asDecimal(_ value: Any?) -> Decimal? {
        if let ret = value as? String {
            return Decimal(string: ret)
        }
        
        return nil
    }
}

public struct ForecastHour {
    let day: String?
    let time: String?
    let temperature: Int?
    let precipitation: Precipitation?
    let precipitationChance: Int?
    let symbol: Symbol?
    let humidity: Int?
    let conditions: String?
    let conditionsFormatted: String?
    let wind: Wind?
    let sky: Int?
    
    var temperatureFormatted: String {
        guard let temperature = self.temperature else {
            return "-"
        }
        return String(format: "%d˚", temperature)
    }
    
    
    var precipitationFormatted: String {
        guard let precip = self.precipitationChance else {
            return "-"
        }
        return String(format: "%d%%", precip)
    }
    
    var skyFormatted: String {
        guard let sky = self.sky else {
            return "-"
        }
        return String(format: "%d%%", sky)
    }
    
    var windSustainedFormatted: String {
        guard let wind = self.wind?.sustained else {
            return "-"
        }
        return String(format: "%d mph", wind)
    }
    
    var humidityFormatted: String {
        guard let humidity = self.humidity else {
            return "-"
        }
        return String(format: "%d%%", humidity)
    }
    
    static func parseHourly(hourlies: [[String: Any]]?) -> [ForecastHour]? {
        
        guard let hourlies = hourlies else {
            return nil
        }
        
        var forecasts = [ForecastHour]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for hourly in hourlies {
            if let day = hourly["dy"] as? String {
                
                // Time
                var time: String?
                if let ti = hourly["ti"] as? String {
                    time = ti
                }
                
                // Temperature
                var temperature: Int?
                if let t = hourly["t"] as? String {
                    temperature = Int(t)
                }
                
                // Precipitation amount
                var rain: Decimal?
                if let r = hourly["r"] as? String {
                    rain = Decimal(string: r)
                }
                
                var snow: Decimal?
                if let s = hourly["s"] as? String {
                    snow = Decimal(string: s)
                }
                
                let precipitation = Precipitation(rain: rain, snow: snow)
                
                // Precipitation chance
                var precipChance: Int?
                if let p = hourly["p"] as? String {
                    precipChance = Int(p)
                }
                
                // Symbol
                var symbol: Symbol?
                if let sym = hourly["sy"] as? String {
                    symbol = Symbol(rawValue: sym)
                }
                
                // Conditions
                var conditions: String?
                if let w = hourly["w"] as? String {
                    conditions = w
                }
                
                var conditionsFormatted: String?
                if let c = hourly["c"] as? String {
                    conditionsFormatted = c
                }
                
                // Humidity
                var humidity: Int?
                if let h = hourly["h"] as? String {
                    humidity = Int(h)
                }
                
                // Wind
                var windSustained: Int?
                if let ws = hourly["ws"] as? String {
                    windSustained = Int(ws)
                }
                
                var windGust: Int?
                if let wg = hourly["wg"] as? String {
                    windGust = Int(wg)
                }
                
                let wind = Wind(sustained: windSustained, gust: windGust)
                
                var sky: Int?
                if let sk = hourly["sk"] as? String {
                    sky = Int(sk)
                }
                
                let forecast = ForecastHour(
                    day: day, time: time,
                    temperature: temperature, precipitation: precipitation,
                    precipitationChance: precipChance,
                    symbol: symbol, humidity: humidity, conditions: conditions, conditionsFormatted: conditionsFormatted,
                    wind: wind, sky: sky)
                forecasts.append(forecast)
            }
        }
        return forecasts
    }
}

struct ForecastDaily {
    let forecastDays: [ForecastDay]
}

struct ForecastHourly {
    let forecastHours: [ForecastHour]
}
