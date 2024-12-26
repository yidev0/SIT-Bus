//
//  TimetableValue.swift
//  School Bus
//
//  Created by Yuto on 2024/08/16.
//

import Foundation

struct SchoolBusTimetable {
    var values: [Value]
    
    func getNextBus(for date: Date) -> Date? {
        let currentHour = date.get(component: .hour)
        
        for value in values {
            if value.hour == currentHour {
                for time in value.times where time >= date {
                    return time
                }
            }
            
            // If the hour is in the future, return the first minute of that hour
            if value.hour > currentHour {
                if let firstTime = value.times.first {
                    return firstTime
                }
            }
        }
        return nil
    }
    
    func getNextBusNote(for currentDate: Date, nextBusDate: Date = .distantFuture) -> (start: Date, end: Date)? {
        if let range = values.first(
            where: {
                currentDate < nextBusDate && currentDate < ($0.dateRange1 ?? .distantPast) && ($0.dateRange2 ?? .distantFuture) < nextBusDate
            }
        ) {
            if let range1 = range.dateRange1, let range2 = range.dateRange2 {
                return (range1, range2)
            }
        }
        
        return nil
    }
}

extension SchoolBusTimetable {
    struct Value {
        let hour: Int
        let times: [Date]
        
        let note: String?
        
        let dateRange1: Date?
        let dateRange2: Date?
        
        init(inputDate: Date, hour: Int, times: [Int], note: String?, dateRange1: Date? = nil, dateRange2: Date? = nil) {
            self.hour = hour
            self.times = times.map { minute in
                return Date.createDate(
                    year: inputDate.get(component: .year),
                    month: inputDate.get(component: .month),
                    day: inputDate.get(component: .day),
                    hour: hour,
                    minute: minute,
                    second: 59
                ) ?? .now
            }
            self.note = note
            self.dateRange1 = dateRange1
            self.dateRange2 = dateRange2
        }
    }
}
