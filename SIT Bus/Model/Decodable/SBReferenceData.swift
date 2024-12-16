//
//  SBReferenceData.swift
//  School Bus
//
//  Created by Yuto on 2024/08/13.
//

import Foundation
import SwiftUI

struct SBReferenceData: Decodable {
    let update: String
    let timesheet: [SBTimeSheet]
    let calendar: [SBCalendar]
    let siteInfo: [SBSiteInfo]
    
    private enum CodingKeys: String, CodingKey {
        case update
        case timesheet
        case calendar
        case siteInfo = "site_info"
    }
    
    private func getTimesheetID(for date: Date) -> String? {
        let components = Calendar.current.dateComponents(in: .current, from: date)
        let year = components.year ?? -1
        let month = components.month ?? -1
        let day = components.day ?? -1
        
        if let currentCalendar = self.calendar.first(where: {
            $0.year == String(format: "%02d", year) &&
            $0.month == String(format: "%02d", month)
        }) {
            let currentCalendarList = currentCalendar.list
            let id = currentCalendarList.first(where: { $0.day == String(day) })?.ts_id
            return id
        }
        
        return nil
    }
    
    public func getTimesheet(for date: Date) -> SBTimeSheet? {
        if let id = getTimesheetID(for: date) {
            let timesheet = timesheet.first(where: { $0.ts_id == id })
            return timesheet
        }
        
        return nil
    }
    
    public func getActiveDays() -> [[Date]] {
        var dates: [[Date]] = []
        for calendar in self.calendar {
            dates.append(calendar.getActiveDates())
        }
        
        return dates
    }
    
    public func getNextBus(for type: BusLineType.SchoolBus, date: Date) -> Date? {
        let currentHour = date.get(component: .hour)
        
        if let timetable = getTimesheet(for: date)?.makeTimetable(for: type) {
            for timetable in timetable {
                if timetable.hour == currentHour {
                    for time in timetable.times where time >= .now {
                        return time
                    }
                }
                
                // If the hour is in the future, return the first minute of that hour
                if timetable.hour > currentHour {
                    if let firstTime = timetable.times.first {
                        return firstTime
                    }
                }
            }
        }
        
        return nil
    }
    
    public func getBusNote(for type: BusLineType.SchoolBus, date: Date) -> (start: Date, end: Date)? {
        if let timetable = getTimesheet(for: date)?.makeTimetable(for: type) {
            let noteRanges: [(Date, Date, String)] = timetable.compactMap { value in
                if let range1 = value.dateRange1, let range2 = value.dateRange2, let note = value.note {
                    return (range1, range2, note)
                }
                return nil
            }
            
            let currentHour = date.get(component: .hour)
            let currentMinute = date.get(component: .minute)
            
            for range in noteRanges {
                let (start, end, _) = range
                let (startHour, startMinute) = (start.get(component: .hour), start.get(component: .minute))
                let (endHour, endMinute) = (end.get(component: .hour), end.get(component: .minute))
                
                let startTotalMinutes = startHour * 60 + startMinute - 10
                let endTotalMinutes = endHour * 60 + endMinute
                let currentTotalMinutes = currentHour * 60 + currentMinute
                
                if currentTotalMinutes >= startTotalMinutes && currentTotalMinutes <= endTotalMinutes {
                    return (start, end)
                }
            }
        }
        return nil
    }
    
}
