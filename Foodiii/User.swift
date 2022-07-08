//
//  User.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation
import Swift

struct User: Identifiable, Codable {
    var id: String = UUID().uuidString
    var firstName = ""
    var lastName = ""
    var email = ""
    var location = ""
    var profileImageUrl = ""
}

extension User {
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case location
        case profileImageUrl = "profile_image_url"
    }
}
        
class UserObservable: ObservableObject {
    let idKey = "id"
    let firstNameKey = "firstName"
    let lastNameKey = "lastName"
    let emailKey = "email"
    let locationKey = "location"
    let profileImageUrlKey = "profileImageUrl"
    let isNewUserKey = "isNewUser"
    let latitudeKey = "latitude"
    let longitudeKey = "longitude"
    let zoomKey = "zoom"
    
    var id: String
    
    @Published var firstName: String {
        didSet {
            UserDefaults.standard.setValue(firstName, forKey: "\(firstNameKey)-\(id)")
        }
    }
    
    @Published var lastName: String {
        didSet {
            UserDefaults.standard.setValue(lastName, forKey: "\(lastNameKey)-\(id)")
        }
    }
    
    @Published var email: String {
        didSet {
            UserDefaults.standard.setValue(email, forKey: "\(emailKey)-\(id)")
        }
    }
    
    @Published var location: String {
        didSet {
            UserDefaults.standard.setValue(location, forKey: "\(locationKey)-\(id)")
        }
    }
    
    @Published var profileImageUrl: String {
        didSet {
            UserDefaults.standard.setValue(profileImageUrl, forKey: "\(profileImageUrlKey)-\(id)")
        }
    }
    
    @Published var isNewUser: Bool {
        didSet {
            UserDefaults.standard.setValue(isNewUser, forKey: "\(isNewUserKey)-\(id)")
        }
    }
    
    @Published var latitude: Double {
        didSet {
            UserDefaults.standard.setValue(latitude, forKey: latitudeKey)
        }
    }
    
    @Published var longitude: Double {
        didSet {
            UserDefaults.standard.setValue(longitude, forKey: longitudeKey)
        }
    }
    
    @Published var zoom: Double {
        didSet {
            UserDefaults.standard.setValue(zoom, forKey: zoomKey)
        }
    }
    
    func setId(to newId: String) {
        UserDefaults.standard.setValue(newId, forKey: idKey)
    }
    
    init() {
        id = UserDefaults.standard.string(forKey: idKey) ?? ""
        firstName = UserDefaults.standard.string(forKey: "\(firstNameKey)-\(id)") ?? ""
        lastName = UserDefaults.standard.string(forKey: "\(lastNameKey)-\(id)") ?? ""
        email = UserDefaults.standard.string(forKey: "\(emailKey)-\(id)") ?? ""
        location = UserDefaults.standard.string(forKey: "\(locationKey)-\(id)") ?? ""
        profileImageUrl = UserDefaults.standard.string(forKey: "\(profileImageUrlKey)-\(id)") ?? ""
        isNewUser = UserDefaults.standard.bool(forKey: "\(isNewUserKey)-\(id)")
        latitude = UserDefaults.standard.double(forKey: latitudeKey)
        longitude = UserDefaults.standard.double(forKey: longitudeKey)
        zoom = UserDefaults.standard.double(forKey: zoomKey)
    }
}
