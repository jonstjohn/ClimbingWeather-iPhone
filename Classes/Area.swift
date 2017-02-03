//
//  Area.swift
//  climbingweather
//
//  Created by Jon St. John on 2/2/17.
//
//

import Foundation

struct Area {
    let name: String
    let areas: Int
    let code: String
}

struct Areas {
    
    var areas = [Area]()
    
    public init?(jsonStr: String) {
        
        guard let data = jsonStr.data(using: .utf8) else {
            return nil
        }
        
        self.init(jsonData: data)
        
    }
    
    public init?(jsonData: Data) {
        
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonAreas = json as? [[String: String]] else {
            return nil
        }
        
        for jsonArea in jsonAreas {
            if let name = jsonArea["name"],
                let areasFromJson = jsonArea["areas"],
                let areaCount = Int(areasFromJson),
                let code = jsonArea["code"] {
                self.areas.append(Area(name: name, areas: areaCount, code: code))
            }
        }
        
    }
}
