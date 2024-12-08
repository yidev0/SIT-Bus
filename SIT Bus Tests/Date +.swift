//
//  Date +.swift
//  School BusTests
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
}
