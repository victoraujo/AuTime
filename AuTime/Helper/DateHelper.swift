//
//  DateHelper.swift
//  AuTime
//
//  Created by Matheus Andrade on 03/08/21.
//

import Foundation

class DateHelper {
    
    /// Parse date to formatted string
    /// - Parameter date: Date to be formatted
    /// - Returns: String containing weekday and date
    class func getDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        let days = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        
        return days[weekDay-1] + ", " + dateFormatter.string(from: date)
    }
    
    /// Get Hours and Minutes from a date
    /// - Parameter date: Date to be parsed
    /// - Returns: String containing onlye hours and minutes
    class func getHoursAndMinutes(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return timeString
    }
    
}
