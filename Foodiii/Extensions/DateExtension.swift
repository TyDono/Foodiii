//
//  DateExtension.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/28/22.
//

import Foundation
import Foundation

extension Date {
    
    // Referenced from: https://appchance.com/blog/handling-time-zones-on-ios
    
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss'Z'"
            dateFormatter.timeZone = TimeZone(identifier: "GMT")

            return dateFormatter
        }()
    }

    var dateToUTC: String {
        return Formatter.utcFormatter.string(from: self)
    }
    
    func minutesFromNow() -> Int {
        if let date = Date().dateToUTC.dateFromUTC, let minutes = Calendar.current.dateComponents([.minute], from: date, to: self).minute {
            return minutes
        }
        
        return 0
    }
    
    func getElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: self, to: Date())

        if let year = interval.year, year > 0 {
            return "\(year)y"
        } else if let month = interval.month, month > 0 {
            return "\(month)mo"
        } else if let week = interval.weekOfYear, week > 0 {
            return "\(week)w"
        } else if let day = interval.day, day > 0 {
            return "\(day)d"
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour)h"
        } else if let minutes = interval.minute {
            return "\(minutes)m"
        } else {
            return ""
        }
    }
    
}
