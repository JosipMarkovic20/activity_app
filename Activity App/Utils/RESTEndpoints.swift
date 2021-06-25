//
//  RESTEndpoints.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
public enum RestEndpoints{
    static var scheme: String{
      return Bundle.main.infoDictionary!["API_BASE_SCHEME"] as! String
    }
    
    static var host: String{
        Bundle.main.infoDictionary!["API_BASE_HOST"] as! String
    }
    
    static var path: String{
        Bundle.main.infoDictionary!["API_BASE_PATH"] as! String
    }
    
    public static var ENDPOINT: String {
        return scheme + host + path
    }

    case activity
    
    public func endpoint() -> String {
        
        switch self {
        case .activity:
            return RestEndpoints.ENDPOINT + "activity"
        }
    }
}
