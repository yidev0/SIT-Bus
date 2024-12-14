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

        return calendar.date(from: dateComponents)
    }
    
    public func get(component: Calendar.Component) -> Int {
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
        return "\(get(component: .year)).\(getMonthText())"
    }
    
    public func convertToMinutes() -> Int {
        self.get(component: .hour) * 60 + self.get(component: .minute)
    }
}
