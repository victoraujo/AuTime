//
//  DateHelper.swift
//  AuTime
//
//  Created by Matheus Andrade on 03/08/21.
//

import Foundation

class DateHelper {
    
    /// Get Hours and Minutes from a date
    /// - Parameter date: Date to be parsed
    /// - Returns: String containing onlye hours and minutes
    class func getHoursAndMinutes(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    /// Parse date to formatted string
    /// - Parameter date: Date to be formatted
    /// - Returns: String containing weekday and date
    class func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        
        return days[weekDay-1] + ", " + dateFormatter.string(from: date)
    }
    
    class func getDateFormatted(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: date)        
    }
    
    class func addNumberOfDaysToDate(date: Date, count: Int) -> Date {
        let newComponent = DateComponents(day: count)
        guard let newDate = Calendar.current.date(byAdding: newComponent, to: date) else {
            return date
        }
        return newDate
    }
    
    class func dayWeekIndex(offset: Int) -> Int {
        let newDate = addNumberOfDaysToDate(date: Date(), count: offset)
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: newDate)
        
        return weekDay - 1
    }
    
    class func datesMatch(_ date1: Date, _ date2: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: date1) == dateFormatter.string(from: date2)
    }
    
}
