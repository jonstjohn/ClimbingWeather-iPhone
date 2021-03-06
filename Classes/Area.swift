//
//  Area.swift
//  climbingweather
//
//  Created by Jon St. John on 2/2/17.
//
//

import Foundation
import SQLite

public struct Area: Equatable {
    let id: Int
    let name: String
    let state: String
    let latitude: String?
    let longitude: String?
    let daily: [ForecastDay]?
    let hourly: [ForecastHour]?
    
    var hourlyByDay: [[ForecastHour]]? {
        guard let hourly = self.hourly else {
            return nil
        }
        
        var hourlyByDay = [[ForecastHour]]()
        var currentDay: String?
        var index = -1
        
        for hour in hourly {
            guard let day = hour.day else {
                continue
            }
            
            if day != currentDay {
                index = index + 1
                currentDay = day
            }
            
            // Initialize array
            if index >= hourlyByDay.count {
                hourlyByDay.append([ForecastHour]())
            }
            
            hourlyByDay[index].append(hour)

        }
        
        return hourlyByDay
    }
    
    public init(id: Int, name: String, state: String, daily: [ForecastDay]?, hourly: [ForecastHour]?,
                latitude: String?, longitude: String?) {
        self.id = id
        self.name = name
        self.state = state
        self.daily = daily
        self.hourly = hourly
        self.latitude = latitude
        self.longitude = longitude
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
        self.latitude = nil
        self.longitude = nil
        
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
        self.latitude = nil
        self.longitude = nil
        
    }
    
    public init?(id: Int, detailJsonData: Data) {
        
        let json = try? JSONSerialization.jsonObject(with: detailJsonData, options: [])
        
        guard let result = json as? [String: Any],
            let name = result["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.state = "" // TODO
        self.latitude = result["latitude"] as? String
        self.longitude = result["longitude"] as? String
        self.daily = nil
        self.hourly = nil
        
    }
    
    public static func ==(lhs: Area, rhs: Area) -> Bool {
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
    
    /**
     * Fetch detail for area
     */
    static func fetchDetail(id: Int, completion: @escaping (Area) -> Void) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let searchURL = APIUrl().areaDetailUrl(areaId: id).url {
            
            session.dataTask(with: searchURL, completionHandler: { (data, response, error) -> Void in
                
                if let data = data, let area = Area(id: id, detailJsonData: data) {
                    completion(area)
                }
                
            }).resume()
        }
    }
    
    
    static func favorites(database: CWDatabase? = CWDatabase.sharedInstance) throws -> [Area]? {
        
        guard let favorites = FavoriteTable() else {
            throw DataAccessError.Connection_Error
        }
        
        let areas = try favorites.areas()
        return areas

    }
        
//        guard let connection = database?.connection else {
//            return nil
//        }
//        
//        let favorites = Table("favorite")
//        let id = Expression<Int>("area_id")
//        let name = Expression<String>("name")
//        
//        var areas = [Area]()
//        
//        do {
//            for favorite in try connection.prepare(favorites) {
//                areas.append(Area(id: favorite[id], name: favorite[name], state: "", daily: nil, hourly: nil, latitude: nil, longitude: nil))
//            }
//        } catch _ {
//            return nil
//        }
//        
//        return areas
//    }
    
    func isFavorite() throws -> Bool {
        
        guard let favorites = FavoriteTable() else {
            throw DataAccessError.Connection_Error
        }
        
        return try favorites.exists(self.id)

//        guard let favorites = Area.favorites() else {
//            return false
//        }
//        return favorites.contains(self)
    }
    
    func addFavorite() throws {
        
        guard try !self.isFavorite() else {
            return
        }
        
        guard let favorites = FavoriteTable() else {
            throw DataAccessError.Connection_Error
        }
        
        try favorites.insert(self.id, name: self.name)
        
//        guard let connection = CWDatabase.sharedInstance?.connection else {
//            return
//        }
//        
//        let favorites = Table("favorite")
//        let id = Expression<Int>("area_id")
//        let name = Expression<String>("name")
//        
//        let insert = favorites.insert(id <- self.id, name <- self.name)
//        try connection.run(insert)
    }
    
    func removeFavorite() throws {
        guard try self.isFavorite() else {
            return
        }
        
        guard let favorites = FavoriteTable() else {
            throw DataAccessError.Connection_Error
        }
        
        try favorites.remove(self.id)
        
        
        
//        guard let connection = CWDatabase.sharedInstance?.connection else {
//            return
//        }
//        
//        let favorites = Table("favorite")
//        let id = Expression<Int>("area_id")
//        
//        let areaRow = favorites.filter(id == self.id)
//        try connection.run(areaRow.delete())
    }
    
}

enum DataAccessError: Error {
    case Connection_Error
}

struct FavoriteTable {
    
    let table = Table("favorite")
    let id = Expression<Int>("area_id")
    let name = Expression<String>("name")
    
    init?() {
        do {
            try ensureTableExists()
        } catch {
            return nil
        }
    }
    
    func connection() throws -> Connection {
        guard let connection = CWDatabase.sharedInstance?.connection else {
            throw DataAccessError.Connection_Error
        }
        return connection
    }
    
    func ensureTableExists() throws {
        try self.connection().run( table.create(ifNotExists: true) {t in
            t.column(id, primaryKey: true)
            t.column(name)
        })
    }
    
    func insert(_ areaId: Int, name areaName: String) throws {
        let insert = self.table.insert(id <- areaId, name <- areaName)
        try self.connection().run(insert)
    }
    
    func remove(_ areaId: Int) throws {
        let areaRow = self.table.filter(id == areaId)
        try self.connection().run(areaRow.delete())
        
    }
    
    func exists(_ areaId: Int) throws -> Bool {
        return try self.connection().scalar(self.table.filter(id == areaId).count) == 1
    }
    
    func areas() throws -> [Area] {
        
        var areas = [Area]()

        for favorite in try self.connection().prepare(self.table) {
            areas.append(Area(id: favorite[self.id], name: favorite[self.name], state: "", daily: nil, hourly: nil, latitude: nil, longitude: nil))
        }
        
        return areas
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
                
                let forecastDaily = jsonArea["f"] as? [[String: Any]]
                let daily = ForecastDay.parseDaily(dailies: forecastDaily)
                let area = Area(id: id, name: name, state: state, daily: daily, hourly: nil, latitude: nil, longitude: nil)
                self.areas.append(area)
            }
        }
        
    }
    
    // TODO - implement search term / criteria, API key, units, maybe even days
    static func fetchDaily(search: AreaSearch, completion: @escaping (Areas) -> Void) {
        
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
