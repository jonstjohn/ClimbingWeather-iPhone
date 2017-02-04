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
                self.areas.append(Area(id: id, name: name, state: state, daily: nil, hourly: nil))
            }
        }
        
    }
    
    static func fetchDaily(search: String, completion: @escaping (Areas) -> Void) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let searchURL = URL(string: "http://api.climbingweather.com/api/area/list/cottonwood?days=3&apiKey=iphone-VALID&tempUnit=F") {
            
            session.dataTask(with: searchURL, completionHandler: { (data, response, error) -> Void in
                
                if let data = data, let areas = Areas(dailyJsonData: data) {
                    completion(areas)
                }
                
            }).resume()
        }
    }
}
