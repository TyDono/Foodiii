//
//  NetworkRequestService.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/27/22.
//

import Foundation

final class NetworkRequestService {
    private init() {}
    static let shared = NetworkRequestService()
    
    func getPost() { // make parameters
        let urlString = ""
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
//                let decodedResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
//                self.categories = decodedResponse.categories
//                self.categories = self.categories.sorted { $0.strCategory < $1.strCategory }
                DispatchQueue.main.async {
                    
                }
                return
            }
            catch {
                print(error)
            }
            print("Fetch failed: \(String(describing: error))")
        }.resume()
        
    }
}
