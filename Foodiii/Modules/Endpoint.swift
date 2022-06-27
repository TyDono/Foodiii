//
//  Endpoint.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/27/22.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
    
}
