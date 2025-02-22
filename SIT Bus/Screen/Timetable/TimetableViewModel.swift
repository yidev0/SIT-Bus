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
        isActiveDate = toCampusTimetable != nil || toStationTimetable != nil
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
    
}
