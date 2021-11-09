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
    
    /// String formatted by Day-Month-Year
    /// - Parameter date: Source date
    /// - Returns: String with formatted date
    class func getDateFormatted(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    /// Convert a date to string
    /// - Parameter date: Source date
    /// - Returns: String with the specific format
    class func dateToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    /// Convert a string to date
    /// - Parameter string: String description
    /// - Returns: Date object with the specific format
    class func stringToDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: string) ?? Date()
        
    }
    
    /// Add a number of days from a specific day
    /// - Parameters:
    ///   - date: Source date
    ///   - count: Number of days to add
    /// - Returns: New date after 'count' days
    class func addNumberOfDaysToDate(date: Date, count: Int) -> Date {
        let newComponent = DateComponents(day: count)
        guard let newDate = Calendar.current.date(byAdding: newComponent, to: date) else {
            return date
        }
        return newDate
    }
    
    /// The index of day in a week
    /// - Parameter offset: Number of days after today
    /// - Returns: The index of day in a week
    class func dayWeekIndex(offset: Int) -> Int {
        let newDate = addNumberOfDaysToDate(date: Date(), count: offset)
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: newDate)
        
        return weekDay - 1
    }
    
    /// Compare if two dates has the same day, month and year
    /// - Parameters:
    ///   - date1: First date
    ///   - date2: Second date
    /// - Returns: Bool indicating if two dates are equals
    class func datesMatch(_ date1: Date, _ date2: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date1) == dateFormatter.string(from: date2)
    }
    
}
