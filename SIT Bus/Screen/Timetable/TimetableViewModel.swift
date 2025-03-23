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
    }
    
    init(date: Date) {
        self.timesheetDate = date
    }
        
    func makeTimesheet(data: SBReferenceData?) {
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
            switch schoolBusIwatsuki {
            case .campusToStation:
                IwatsukiBusData.toStation
            case .stationToCampus:
                IwatsukiBusData.toCampus
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
