//
//  Constants.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation
import SwiftUI

enum Colors {
    static let green = Color(red: 2/255, green: 97/255, blue: 104/255)
    static let greenDark = Color(red: 2/255, green: 61/255, blue: 79/255)
    static let green35 = Color(red: 2/255, green: 97/255, blue: 104/255).opacity(0.35)
    static let turtleGreen = Color(red: 129/255, green: 192/255, blue: 84/255)
    
    static let greyLight = Color(red: 239/255, green: 239/255, blue: 239/255)
    static let greyMedium = Color(red: 155/255, green: 155/255, blue: 155/255)
    static let greyDark = Color(red: 74/255, green: 74/255, blue: 74/255)
    static let lightGreyTwo = Color(red: 219/255, green: 219/255, blue: 219/255)
    static let lightGreyThree = Color(red: 210/255, green: 210/255, blue: 210/255)
    static let lightGreyFour = Color(red: 245/255, green: 245/255, blue: 245/255)
    
    static let darkGreyTwo = Color(red: 44/255, green: 44/255, blue: 46/255)
    static let darkGreyThree = Color(red: 183/255, green: 183/255, blue: 190/255)
    static let darkGreyFour = Color(red: 105/255, green: 105/255, blue: 105/255)
    
    static let error = Color(red: 208/255, green: 2/255, blue: 27/255)
    static let red10 = Color(red: 255/255, green: 0/255, blue: 0/255).opacity(0.1)
    static let redLight = Color(red: 226/255, green: 108/255, blue: 123/255)
    
    static let foodiBrown = Color(red: 166/255, green: 113/255, blue: 0/255)
    static let foodiYellow = Color(red: 255/255, green: 209/255, blue: 0/255)
    
    static let black70 = Color(red: 0/255, green: 0/255, blue: 0/255).opacity(0.7)
    static let black26 = Color(red: 0/255, green: 0/255, blue: 0/255).opacity(0.26)
    static let black16 = Color(red: 0/255, green: 0/255, blue: 0/255).opacity(0.16)
}

enum AnalyticsEvents {
    
    
    static let signUpWithGoogle = "sign_up_with_google"
    static let signUpWithApple = "sign_up_with_apple"
    
    static let logInWithGoogle = "log_in_with_google"
    static let logInWithApple = "log_in_with_apple"
    
}
