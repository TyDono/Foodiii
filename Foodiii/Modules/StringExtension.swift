//
//  StringExtension.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/28/22.
//

import Foundation
import Foundation

extension String {
    
    // Referenced from: https://appchance.com/blog/handling-time-zones-on-ios
    
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssz"
            
            return dateFormatter
        }()
    }
    
    func toDateString(inputDateFormat inputFormat: String,  ouputDateFormat outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date!)
    }
    
    var dateFromUTC: Date? {
        return Formatter.utcFormatter.date(from: self)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[(?=.*gmail)(?=.*yahoo)]{5}+\\.[A-Za-z]{3}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    var isValidPassword: Bool{
        let passRegEx = "[A-Z0-9a-z.!@#$%^&*]{6,30}"
        return NSPredicate(format: "SELF MATCHES %@", passRegEx).evaluate(with: self)
    }
    
    var isValidUserPass: Bool{
        let userPassRegEx = "[A-Za-z]{2,30}"
        return NSPredicate(format: "SELF MATCHES %@", userPassRegEx).evaluate(with: self)
    }
    
}
