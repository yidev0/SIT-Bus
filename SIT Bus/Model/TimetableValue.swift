//
//  TimetableValue.swift
//  School Bus
//
//  Created by Yuto on 2024/08/16.
//

import Foundation

struct TimetableValue {
    let hour: Int
    let times: [Date]
    
    let note: String?
    
    let dateRange1: Date?
    let dateRange2: Date?
    
    init(hour: Int, times: [Int], note: String?, dateRange1: Date? = nil, dateRange2: Date? = nil) {
        self.hour = hour
        self.times = times.map { minute in
            return Calendar.current.date(
                bySettingHour: hour,
                minute: minute,
                second: 59,
                of: .now
            ) ?? .now
        }
        self.note = note
        self.dateRange1 = dateRange1
        self.dateRange2 = dateRange2
    }
}
