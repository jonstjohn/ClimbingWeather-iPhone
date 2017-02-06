//
//  Area.swift
//  climbingweather
//
//  Created by Jon St. John on 2/2/17.
//
//

import Foundation

struct Area {
    let id: Int
    let name: String
    let state: String
    let daily: [ForecastDay]?
    let hourly: [ForecastHour]?
}

struct Areas {
    
    var areas = [Area]()
    
    public init?(dailyJsonStr: String) {
        
        guard let data = dailyJsonStr.data(using: .utf8) else {
            return nil
        }
        
        self.init(dailyJsonData: data)
        
    }
    
    public init?(dailyJsonData: Data) {
        
        let json = try? JSONSerialization.jsonObject(with: dailyJsonData, options: [])
        
        guard let result = json as? [String: Any] else {
            return nil
        }
        
        guard let status = result["status"] as? String else {
            return nil
        }
        
        guard status == "OK" else {
            return nil
        }
        
        guard let jsonAreas = result["results"] as? [[String: Any]] else {
            return nil
        }
        
        for jsonArea in jsonAreas {
            if let id = jsonArea["id"] as? Int,
                let name = jsonArea["name"] as? String,
                let state = jsonArea["state"] as? String {
                
                let forecastDaily = jsonArea["f"] as? [[String: String]]
                self.areas.append(Area(id: id, name: name, state: state, daily: self.parseDaily(dailies: forecastDaily), hourly: nil))
            }
        }
        
    }
    
    private func parseDaily(dailies: [[String: String]]?) -> [ForecastDay]? {
        
        guard let dailies = dailies else {
            return nil
        }
        
        var days = [ForecastDay]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for daily in dailies {
            if let dateStr = daily["d"], let date = dateFormatter.date(from: dateStr) {
                
                var high: Int?
                if let hi = daily["hi"] {
                    high = Int(hi)
                }
                
                var low: Int?
                if let lo = daily["l"] {
                    low = Int(lo)
                }
                
                var precipChanceDay: Int?
                if let pd = daily["pd"] {
                    precipChanceDay = Int(pd)
                }
                
                var precipChanceNight: Int?
                if let pn = daily["pn"] {
                    precipChanceNight = Int(pn)
                }
                
                var symbol: Symbol?
                if let sym = daily["sy"] {
                    symbol = Symbol(rawValue: sym)
                }
                
                let day = ForecastDay(
                    date: date, day: nil, dateFormatted: nil,
                    high: high, low: low, precipitation: nil,
                    precipitationChanceDay: precipChanceDay, precipitationChanceNight: precipChanceNight,
                    symbol: symbol, humidity: nil)
                days.append(day)
            }
        }
        return days
    }
    
    // TODO - implement search term / criteria, API key, units, maybe even days
    static func fetchDaily(search: Search, completion: @escaping (Areas) -> Void) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let searchURL = APIUrl().searchURL(search: search).url {
            
            session.dataTask(with: searchURL, completionHandler: { (data, response, error) -> Void in
                
                if let data = data, let areas = Areas(dailyJsonData: data) {
                    completion(areas)
                }
                
            }).resume()
        }
    }
}
