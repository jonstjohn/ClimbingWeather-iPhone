//
//  CWApi.swift
//  climbingweather
//
//  Created by Jon St. John on 2/6/17.
//
//

import Foundation

struct Location {
    let latitude: String
    let longitude: String
}

enum Search {
    case Term(String)
    case Location(Location)
    case State(String)
    
}

struct APIUrl {
    
    let scheme = "http"
    let host = "api.climbingweather.com"
    let base = "/api"
    
    var myurl: URLComponents {
        return url(withPath: "yo", queryItems: nil)
    }
    
    func url(withPath path:String, queryItems: [URLQueryItem]?) -> URLComponents {
        var url = URLComponents()
        url.scheme = self.scheme
        url.host = self.host
        url.path = base + "/" + path
        
        var qItems = [
            URLQueryItem(name: "apiKey", value: "iphone-VALID"),
            URLQueryItem(name: "tempUnit", value: "F")
        ]
        
        if let items = queryItems {
            qItems = qItems + items
        }
        
        url.queryItems = qItems
        
        return url
    }
    
    func searchURL(search: Search) -> URLComponents {
        
        let queryItems = [
            URLQueryItem(name: "days", value: "3"),
            ]
        let path = "area/list/"
        switch search {
        case .Term(let term), .State(let term):
            return url(withPath: path + term, queryItems: queryItems)
        case .Location(let location):
            return url(withPath: path + String(format: "%@,%@", location.latitude, location.longitude), queryItems: queryItems)
            
        }
    }
}
