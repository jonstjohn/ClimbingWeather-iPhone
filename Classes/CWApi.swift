//
//  CWApi.swift
//  climbingweather
//
//  Created by Jon St. John on 2/6/17.
//
//

import Foundation

/**
 * Location
 */
public struct Location {
    let latitude: String
    let longitude: String
}

/**
 * Search types for use with API searches
 */
public enum Search {
    case Term(String)
    case Location(Location)
    case State(State)
    case Areas([Int])
    
    public func empty() -> Bool {
        switch self {
        case .Term(let term):
            return term.count == 0
        case .Location(_):
            return false
        case .State(_):
            return false
        case .Areas(let areas):
            return areas.count == 0
        }
    }
}

/**
 * Temperature units
 */
enum TempUnits {
    case Celsius
    case Fahrenheit
    
    func asParameter() -> String {
        switch self {
        case .Celsius:
            return "c"
        case .Fahrenheit:
            return "f"
        }
    }
}

/**
 * APIUrl describe an API URL that can be used in a request
 */
struct APIUrl {
    
    // Preferences
    var preferences: PreferencesProtocol
    
    // Basic URL information
    let scheme = "http"
    let host = "api.climbingweather.com"
    let base = "/api"
    
    // Custom paths
    let searchPath = "/area/list"
    let statePath = "/state/list"
    let areaDailyPath = "/area/daily"
    let areaHourlyPath = "/area/hourly"
    let areaDetailPath = "/area/detail"
    
    // Constants
    let apiKeyKey = "apiKey"
    let tempUnitKey = "tempUnit"
    
    init(preferences: PreferencesProtocol = Preferences()) {
        self.preferences = preferences
    }
    
    /**
     * Generate a URL using a path and query parameters
     */
    func url(withPath path:String, queryItems: [URLQueryItem]?) -> URLComponents {
        
        var url = URLComponents()
        url.scheme = self.scheme
        url.host = self.host
        url.path = base + path
        
        var qItems = [
            URLQueryItem(name: self.apiKeyKey, value: preferences.apiKey),
            URLQueryItem(name: self.tempUnitKey, value: preferences.tempUnits.asParameter())
        ]
        
        if let items = queryItems {
            qItems = qItems + items
        }
        
        url.queryItems = qItems
        
        return url
    }
    
    /**
     * Generate a search URL
     */
    func searchURL(search: Search, days: Int = 3) -> URLComponents {
        
        let queryItems = [
            URLQueryItem(name: "days", value: String(days)),
            ]
        switch search {
        case .State(let state):
            return url(withPath: self.searchPath + "/" + state.code, queryItems: queryItems)
        case .Term(let term):
            return url(withPath: self.searchPath + "/" + term, queryItems: queryItems)
        case .Location(let location):
            return url(withPath: self.searchPath + "/" + String(format: "%@,%@", location.latitude, location.longitude), queryItems: queryItems)
        case .Areas(let areaIds):
            return url(withPath: self.searchPath + "/ids-" + areaIds.map({String($0)}).joined(separator: ","), queryItems: queryItems)
        }
    }
    
    func stateURL() -> URLComponents {
        return url(withPath: self.statePath, queryItems: nil)
    }
    
    func areaDailyUrl(areaId: Int) -> URLComponents {
        return url(withPath: self.areaDailyPath + "/" + String(areaId), queryItems: nil)
    }
    
    func areaHourlyUrl(areaId: Int) -> URLComponents {
        return url(withPath: self.areaHourlyPath + "/" + String(areaId), queryItems: nil)
    }
    
    func areaDetailUrl(areaId: Int) -> URLComponents {
        return url(withPath: self.areaDetailPath + "/" + String(areaId), queryItems: nil)
    }
}
