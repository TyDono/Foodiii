//
//  RestaurantEndpoint.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/27/22.
//

import Foundation

enum RestaurantEndpoint: Endpoint {
    case wendys
    case mcdonalds
    
    var scheme: String {
        switch self {
//        case <#pattern#>:
//            <#code#>
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
//        case <#pattern#>:
//            <#code#>
        default:
            return ""
        }
    }
    
    var path: String {
        switch self {
        case .wendys:
            return "/"
        case .mcdonalds:
            return "/"

        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .wendys:
            return [URLQueryItem(name: "wednys", value: "US")]
        case .mcdonalds:
            return [URLQueryItem(name: "mcdonalds", value: "US")]
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
}
