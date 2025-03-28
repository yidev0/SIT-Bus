//
//  TimetableViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import Foundation

@Observable
class TimetableViewModel {
    
    var timesheetDate: Date
    var isActiveDate = false
    var isWeekday: Bool
    
    var showTimesheetDatePicker = false
    var showFullTimesheetDatePicker = false
    var showInfoSheet = false
    
    var toCampusTimetable: SchoolBusTimetable? = nil
    var toStationTimetable: SchoolBusTimetable? = nil
    
    /// for iPhone
    var timesheetBus: BusLineType = .schoolBus(.stationToCampus)
    /// For iPad
    var timesheetBusType: BusType = .schoolOmiya
    
    init() {
        timesheetDate = Date.now
        isWeekday = !Calendar.current.isDateInWeekend(.now)
    }
    
    init(date: Date) {
        self.timesheetDate = date
        isWeekday = !Calendar.current.isDateInWeekend(.now)
    }
        
    func makeTimesheet(data: SBReferenceData?) {
        isWeekday = !Calendar.current.isDateInWeekend(timesheetDate)
        timesheetBusType = timesheetBus.busType
        
        toCampusTimetable = data?.makeTimetable(for: .stationToCampus, date: timesheetDate)
        toStationTimetable = data?.makeTimetable(for: .campusToStation, date: timesheetDate)
        // TODO: Check if date is a school day
        switch timesheetBusType {
        case .schoolOmiya:
            isActiveDate = toCampusTimetable != nil || toStationTimetable != nil
        case .schoolIwatsuki, .shuttle:
            isActiveDate = true
        }
    }
    
    func getTimetable(for bus: BusLineType) -> SchoolBusTimetable? {
        switch bus {
        case .schoolBus(let schoolBus):
            switch schoolBus {
            case .campusToStation:
                toStationTimetable
            case .stationToCampus:
                toCampusTimetable
            }
        case .schoolBusIwatsuki(let schoolBusIwatsuki):
            if Date.now >= Date.createDate(year: 2025, month: 4, day: 1)! {
                switch schoolBusIwatsuki {
                case .campusToStation:
                    isWeekday ? IwatsukiBusData.toStationWeekday : IwatsukiBusData.toStationSaturday
                case .stationToCampus:
                    isWeekday ? IwatsukiBusData.toCampusWeekday : IwatsukiBusData.toCampusSaturday
                }
            } else {
                switch (schoolBusIwatsuki, isWeekday) {
                case (.campusToStation, true):
                    IwatsukiBusData.toStation
                case (.stationToCampus, true):
                    IwatsukiBusData.toCampus
                default:
                    nil
                }
            }
        case .shuttleBus:
            nil
        }
    }
    
    func makeRangeForSheet(activeMonths: [[Date]]) -> ClosedRange<Date> {
        let calendar = Calendar.current
        if activeMonths.isEmpty {
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: .now))!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            return startOfMonth ... endOfMonth
        } else if activeMonths.count == 1 {
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: activeMonths.first!.first!))!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            return startOfMonth ... endOfMonth
        } else {
            return activeMonths.first!.first! ... activeMonths.last!.last!
        }
    }
    
}
