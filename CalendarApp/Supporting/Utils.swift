//
//  Utils.swift
//  CalendarApp
//
//  Created by Avinash J Patel on 07/04/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

enum Months: Int {
    case January = 1
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
}

final class Utils {
    static func getCurrentDateComponents() -> DateComponents {
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .year, .month, .day, .weekday], from: date)
        return dateComponents
    }
    
    static func getYear() -> Int {
        let dateComponents = getCurrentDateComponents()
        guard let year = dateComponents.year else { return -1 }
        return year
    }
    
    static func getMonth() -> Int {
        let dateComponents = getCurrentDateComponents()
        guard let month = dateComponents.month else { return -1 }
        return month
    }
    
    static func getMonthString(month: Int) -> String {
        guard let month = Months(rawValue: month) else { return "" }
        let monthStr = "\(month)"
        return monthStr
    }
    
    static func getWeekDay() -> Int {
        let dateComponents = getCurrentDateComponents()
        guard let weekDay = dateComponents.weekday else { return -1 }
        return weekDay
    }
    
    static func getDay() -> Int {
        let dateComponents = getCurrentDateComponents()
        guard let day = dateComponents.day else { return -1 }
        return day
    }
    
    static func getNumberOfDaysIn(month: Int) -> Int {
        let dateComponents = DateComponents(year: getYear(), month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
       
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numOfDays = range.count
        
        return numOfDays
    }
    
    static func getHours() -> Int {
        let dateComponents = getCurrentDateComponents()
        guard let hours = dateComponents.hour else { return -1 }
        return hours
    }
    
    static func getMinutes() -> Int {
        let dateComponents = getCurrentDateComponents()
        guard let minutes = dateComponents.minute else { return -1 }
        return minutes
    }
    
    static func getFirstDayIndexOffset() -> Int {
        let day = getDay()
        let weekday = getWeekDay()
        var firstDayWeekDay = day - weekday
        while firstDayWeekDay > 7 {
            firstDayWeekDay -= 7
        }
        return firstDayWeekDay - 2
    }
}
