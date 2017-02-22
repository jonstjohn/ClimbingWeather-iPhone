//
//  CWDatabase.swift
//  climbingweather
//
//  Created by Jon St. John on 2/21/17.
//
//

import Foundation
import SQLite

class CWDatabase {
    
    static let sharedInstance = CWDatabase()
    let connection: Connection?
    
    private init?() {
        
        let dbFile = "climbingweather.db"
        
        do {
            
            let documentURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dbUrl = documentURL.appendingPathComponent(dbFile)
            
            self.connection = try Connection(dbUrl.absoluteString)
        } catch _ {
            return nil
        }
        
    }
    
    public func favorites() -> [Area]? {

        
        guard let connection = self.connection else {
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
    
}
