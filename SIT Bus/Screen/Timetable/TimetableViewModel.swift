//
//  TimetableViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import Foundation

@Observable
class TimetableViewModel {
    private let settings: AppSettings
    
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
    var busLineType: BusLineType {
        didSet {
            settings.timetableBus = busLineType.rawValue
        }
    }
    /// For iPad
    var busType: BusType {
        didSet {
            settings.timetableBusType = busType.rawValue
        }
    }
    
    init(settings: AppSettings = AppSettings()) {
        self.settings = settings
        
        let busKey = settings.timetableBus
        self.busLineType = .init(name: busKey ?? "") ?? .schoolBus(.stationToCampus)
        
        let busTypeKey = settings.timetableBusType
        self.busType = .init(rawValue: busTypeKey ?? "") ?? .schoolOmiya
    }
}
