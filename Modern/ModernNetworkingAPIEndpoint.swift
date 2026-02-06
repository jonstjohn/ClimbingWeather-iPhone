//
//  APIEndpoint.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// HTTP methods supported by the API
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Protocol defining the structure of an API endpoint
protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

/// All ClimbingWeather API endpoints
enum ClimbingWeatherEndpoint: APIEndpoint {
    // Health
    case healthCheck
    
    // Countries
    case listCountries
    case listAdminAreas(countryISO: String, includeAreas: Bool?, frontPage: Bool?, days: Int?, startDate: String?)
    case getAdminAreaBounds(adminArea: String)
    
    // Areas
    case listAreasByCountry(countryISO: String, startDate: String?, days: Int?, recent: Int?)
    case listAreasByAdminArea(countryISO: String, adminArea: String, days: Int?)
    case searchAreas(query: String)
    case getPopularAreas(limit: Int?, days: Int?, startDate: String?)
    case getFrontPageAreas(days: Int?, startDate: String?)
    
    // Forecasts & Details
    case getAreaForecast(areaId: Int, tempUnit: String?, startDate: String?, days: Int?)
    case getAreaAverages(areaId: Int)
    case getAreaDetail(areaId: Int, includeClim81Station: Bool?)
    
    // Climate Stations
    case getClim81StationDetail(stationId: Int)
    
    var path: String {
        switch self {
        case .healthCheck:
            return "/"
            
        case .listCountries:
            return "/country"
        case .listAdminAreas(let countryISO, _, _, _, _):
            return "/country/\(countryISO)/adminArea"
        case .getAdminAreaBounds(let adminArea):
            return "/state/bounds/\(adminArea)"
            
        case .listAreasByCountry(let countryISO, _, _, _):
            return "/country/\(countryISO)/area"
        case .listAreasByAdminArea(let countryISO, let adminArea, _):
            return "/country/\(countryISO)/adminArea/\(adminArea)/area"
        case .searchAreas(let query):
            return "/area/search/\(query)"
        case .getPopularAreas:
            return "/area/popular"
        case .getFrontPageAreas:
            return "/area/front-page"
            
        case .getAreaForecast(let areaId, _, _, _):
            return "/area/\(areaId)/forecast"
        case .getAreaAverages(let areaId):
            return "/area/\(areaId)/averages"
        case .getAreaDetail(let areaId, _):
            return "/area/\(areaId)/detail"
            
        case .getClim81StationDetail(let stationId):
            return "/clim81/\(stationId)/detail"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        switch self {
        case .listAdminAreas(_, let includeAreas, let frontPage, let days, let startDate):
            if let includeAreas = includeAreas {
                items.append(URLQueryItem(name: "includeAreas", value: "\(includeAreas)"))
            }
            if let frontPage = frontPage {
                items.append(URLQueryItem(name: "frontPage", value: "\(frontPage)"))
            }
            if let days = days {
                items.append(URLQueryItem(name: "days", value: "\(days)"))
            }
            if let startDate = startDate {
                items.append(URLQueryItem(name: "startDate", value: startDate))
            }
            
        case .listAreasByCountry(_, let startDate, let days, let recent):
            if let startDate = startDate {
                items.append(URLQueryItem(name: "startDate", value: startDate))
            }
            if let days = days {
                items.append(URLQueryItem(name: "days", value: "\(days)"))
            }
            if let recent = recent {
                items.append(URLQueryItem(name: "recent", value: "\(recent)"))
            }
            
        case .listAreasByAdminArea(_, _, let days):
            if let days = days {
                items.append(URLQueryItem(name: "days", value: "\(days)"))
            }
            
        case .getAreaForecast(_, let tempUnit, let startDate, let days):
            if let tempUnit = tempUnit {
                items.append(URLQueryItem(name: "tempUnit", value: tempUnit))
            }
            if let startDate = startDate {
                items.append(URLQueryItem(name: "startDate", value: startDate))
            }
            if let days = days {
                items.append(URLQueryItem(name: "days", value: "\(days)"))
            }
            
        case .getAreaDetail(_, let includeClim81Station):
            if let includeClim81Station = includeClim81Station {
                items.append(URLQueryItem(name: "includeClim81Station", value: "\(includeClim81Station)"))
            }
            
        case .getPopularAreas(let limit, let days, let startDate):
            if let limit = limit {
                items.append(URLQueryItem(name: "limit", value: "\(limit)"))
            }
            if let days = days {
                items.append(URLQueryItem(name: "days", value: "\(days)"))
            }
            if let startDate = startDate {
                items.append(URLQueryItem(name: "startDate", value: startDate))
            }
            
        case .getFrontPageAreas(let days, let startDate):
            if let days = days {
                items.append(URLQueryItem(name: "days", value: "\(days)"))
            }
            if let startDate = startDate {
                items.append(URLQueryItem(name: "startDate", value: startDate))
            }
            
        default:
            break
        }
        
        return items
    }
}
