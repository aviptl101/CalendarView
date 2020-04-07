//
//  Utils.swift
//  CalendarApp
//
//  Created by Avinash J Patel on 07/04/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

final class Utils {
    static func getCurrentDateComponents() -> DateComponents {
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .year, .month, .day], from: date)
        return dateComponents
    }
    
    static func getDay() -> Int {
        let dateComponents = getCurrentDateComponents()
        guard let day = dateComponents.day else { return -1 }
        return day
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
}
