//
//  Area.swift
//  climbingweather
//
//  Created by Jon St. John on 2/2/17.
//
//

import Foundation
import SQLite

struct Area: Equatable {
    let id: Int
    let name: String
    let state: String
    let daily: [ForecastDay]?
    let hourly: [ForecastHour]?
    
    public init(id: Int, name: String, state: String, daily: [ForecastDay]?, hourly: [ForecastHour]?) {
        self.id = id
        self.name = name
        self.state = state
        self.daily = daily
        self.hourly = hourly
    }
    
    public init?(id: Int, dailyJsonData: Data) {
        
        let json = try? JSONSerialization.jsonObject(with: dailyJsonData, options: [])
        
        guard let result = json as? [String: Any],
            let status = result["status"] as? String,
            status == "OK",
            let jsonArea = result["results"] as? [String: Any],
            let name = jsonArea["n"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.state = "" // TODO
            
        let forecastDaily = jsonArea["f"] as? [[String: Any]]
        self.daily = ForecastDay.parseDaily(dailies: forecastDaily)
        self.hourly = nil

        
    }
    
    public init?(id: Int, hourlyJsonData: Data) {

        let json = try? JSONSerialization.jsonObject(with: hourlyJsonData, options: [])
        
        guard let result = json as? [String: Any],
            let name = result["n"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.state = "" // TODO
        
        let forecastHourly = result["f"] as? [[String: Any]]
        self.hourly = ForecastHour.parseHourly(hourlies: forecastHourly)
        self.daily = nil
        
    }
    
    static func ==(lhs: Area, rhs: Area) -> Bool {
        return lhs.id == rhs.id
    }
    
    /**
     * Fetch daily forecast for area
     */
    static func fetchDaily(id: Int, completion: @escaping (Area) -> Void) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let searchURL = APIUrl().areaDailyUrl(areaId: id).url {
            
            session.dataTask(with: searchURL, completionHandler: { (data, response, error) -> Void in
                
                if let data = data, let area = Area(id: id, dailyJsonData: data) {
                    completion(area)
                }
                
            }).resume()
        }
    }
    
    /**
     * Fetch hourly forecast for area
     */
    static func fetchHourly(id: Int, completion: @escaping (Area) -> Void) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let searchURL = APIUrl().areaHourlyUrl(areaId: id).url {
            
            session.dataTask(with: searchURL, completionHandler: { (data, response, error) -> Void in
                
                if let data = data, let area = Area(id: id, hourlyJsonData: data) {
                    completion(area)
                }
                
            }).resume()
        }
    }
    
    static func favorites(database: CWDatabase? = CWDatabase.sharedInstance) -> [Area]? {
        
        guard let database = database, let connection = database.connection else {
            return nil
        }
        
        let favorites = Table("favorite")
        let id = Expression<Int>("area_id")
        let name = Expression<String>("name")
        
        var areas = [Area]()
        
        do {
            for favorite in try connection.prepare(favorites) {
                areas.append(Area(id: favorite[id], name: favorite[name], state: "", daily: nil, hourly: nil))
            }
        } catch _ {
            return nil
        }
        
        return areas
    }
    
    func isFavorite() -> Bool {
        guard let favorites = Area.favorites() else {
            return false
        }
        return favorites.contains(self)
    }
    
    func addFavorite() throws {
        guard !self.isFavorite() else {
            return
        }
        
        guard let connection = CWDatabase.sharedInstance?.connection else {
            return
        }
        
        let favorites = Table("favorite")
        let id = Expression<Int>("area_id")
        let name = Expression<String>("name")
        
        let insert = favorites.insert(id <- self.id, name <- self.name)
        try connection.run(insert)
    }
    
    func removeFavorite() throws {
        guard self.isFavorite() else {
            return
        }
        
        guard let connection = CWDatabase.sharedInstance?.connection else {
            return
        }
        
        let favorites = Table("favorite")
        let id = Expression<Int>("area_id")
        
        let areaRow = favorites.filter(id == self.id)
        try connection.run(areaRow.delete())
    }
    
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
                let daily = ForecastDay.parseDaily(dailies: forecastDaily)
                let area = Area(id: id, name: name, state: state, daily: daily, hourly: nil)
                self.areas.append(area)
            }
        }
        
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
