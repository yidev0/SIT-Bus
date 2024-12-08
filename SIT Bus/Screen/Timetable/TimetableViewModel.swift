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
    var timesheetBus: BusLineType = .schoolBus(.stationToCampus)
    var timesheet: [TimetableValue]? = nil
    
    init() {
        timesheetDate = Date.now
    }
    
    init(date: Date) {
        self.timesheetDate = date
    }
        
    func makeTimesheet(data: SBReferenceData?) {
        let sheet = data?.getTimesheet(for: timesheetDate)
        switch timesheetBus {
        case .schoolBus(let schoolBus):
            self.timesheet = sheet?.makeTimetable(for: schoolBus)
        case .shuttleBus(_):
            break
        }
    }
    
}
