//
//  State.swift
//  climbingweather
//
//  Created by Jon St. John on 2/3/17.
//
//

import Foundation

struct State {
    let name: String
    let areas: Int
    let code: String
}

struct States {
    
    var states = [State]()
    
    public init?(jsonStr: String) {
        
        guard let data = jsonStr.data(using: .utf8) else {
            return nil
        }
        
        self.init(jsonData: data)
        
    }
    
    public init?(jsonData: Data) {
        
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonStates = json as? [[String: String]] else {
            return nil
        }
        
        for jsonState in jsonStates {
            if let name = jsonState["name"],
                let areasFromJson = jsonState["areas"],
                let areaCount = Int(areasFromJson),
                let code = jsonState["code"] {
                self.states.append(State(name: name, areas: areaCount, code: code))
            }
        }
        
    }
    
    static func fetchStates(completion: @escaping (States) -> Void) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let searchURL = APIUrl().stateURL().url {
            
            session.dataTask(with: searchURL, completionHandler: { (data, response, error) -> Void in
                
                if let data = data, let states = States(jsonData: data) {
                    completion(states)
                }
                
            }).resume()
        }
    }
}
