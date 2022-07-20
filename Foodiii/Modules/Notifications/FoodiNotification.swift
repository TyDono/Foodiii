//
//  FoodiNotification.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/11/22.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct FoodiNotification: Identifiable, Equatable {
    var id = UUID().uuidString
    let type: NotificationType
    let imageUrl: String
    let message: String
    let datePosted: String
    let intelId: String
    var isRead = false
    
    static func ==(lhs: FoodiNotification, rhs: FoodiNotification) -> Bool {
        return lhs.id == rhs.id
    }
}

enum NotificationType: String {
    case comments = "comments"
    case foodiNotification = "foodiNotification"
}

final class NotificationViewModel: ObservableObject {
    @Published var selectedNotification: FoodiNotification?
}
