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
    var showTimesheetDatePicker = false
    var showInfoSheet = false
    var timesheetBus: BusLineType = .schoolBus(.stationToCampus)
    var timesheetBusType: BusType = .schoolOmiya
    
    var timetable: SchoolBusTimetable? = nil
    
    init() {
        timesheetDate = Date.now
    }
    
    init(date: Date) {
        self.timesheetDate = date
    }
        
    func makeTimesheet(data: SBReferenceData?) {
        switch timesheetBus {
        case .schoolBus(let type):
            self.timetable = data?.makeTimetable(for: type, date: timesheetDate)
        case .shuttleBus(_):
            break
        case .schoolBusIwatsuki(let type):
            switch type {
            case .campusToStation:
                self.timetable = IwatsukiBusData.toIwatsuki
            case .stationToCampus:
                self.timetable = IwatsukiBusData.toCampus
            }
        }
    }
    
}
