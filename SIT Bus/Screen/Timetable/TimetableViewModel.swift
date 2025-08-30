//
//  TimetableViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import Foundation

@Observable
class TimetableViewModel {
    
    var date: Date = .now
    
    var showInfoSheet = false
    var showDatePicker = false
    
    var timetable: BusTimetable? = nil {
        didSet {
            isActive = timetable?.isActive(for: date) ?? false
        }
    }
    var isActive = false
    
    /// for iPhone
    var timesheetBus: BusLineType = .schoolBus(.stationToCampus)
    /// For iPad
    var timesheetBusType: BusType = .schoolOmiya
    
}
