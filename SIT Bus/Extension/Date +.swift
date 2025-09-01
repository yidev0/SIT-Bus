//
//  Date +.swift
//  School Bus
//
//  Created by Yuto on 2024/08/13.
//

import Foundation

extension Date {
    static func createDate(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        dateComponents.timeZone = TimeZone(identifier: "Asia/Tokyo")

        return calendar.date(from: dateComponents)
    }
    
    static func createTime(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int, minute: Int, second: Int = 0) -> Date? {
        let calendar = Calendar.current
        let date = Date.now
        var dateComponents = DateComponents()
        dateComponents.year = year ?? date.get(.year)
        dateComponents.month = month ?? date.get(.month)
        dateComponents.day = day ?? date.get(.day)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        dateComponents.timeZone = TimeZone(identifier: "Asia/Tokyo")

        return calendar.date(from: dateComponents)
    }
    
    static let sample = Date.createDate(year: 2025, month: 1, day: 8, hour: 9, minute: 41, second: 0)!
    
    public func get(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
    
    public func getMonthText() -> String {
        let calendar = Calendar.current
        let months = calendar.monthSymbols
        return months[calendar.component(.month, from: self) - 1]
    }
    
    public func getShortMonthText() -> String {
        let calendar = Calendar.current
        let months = calendar.shortMonthSymbols
        return months[calendar.component(.month, from: self) - 1]
    }
    
    var keyYearMonth: String {
        return "\(get(.year)).\(getMonthText())"
    }
    
    public func convertToMinutes() -> Int {
        self.get(.hour) * 60 + self.get(.minute)
    }
    
    func calendarRows() -> Int {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: self) else {
            return 0
        }
        
        let lastDayOfMonth = calendar.date(bySetting: .day, value: range.count, of: self)!
        return calendar.component(.weekOfMonth, from: lastDayOfMonth)
    }
    
    var isWeekday: Bool {
        let weekday = Calendar.current.component(.weekday, from: self)
        return weekday != 1 && weekday != 7
    }
    
    func startOfDay(after days: Int) -> Date {
        let calendar = Calendar.current
        var date = calendar.startOfDay(for: self)
        date = calendar.date(byAdding: .day, value: days, to: date)!
        return date
    }
}
