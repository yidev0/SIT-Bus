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
    var busLineType: BusLineType {
        didSet {
            UserDefaults.standard.set(busLineType.rawValue, forKey: UserDefaultsKeys.timetableBus)
        }
    }
    /// For iPad
    var busType: BusType {
        didSet {
            UserDefaults.standard.set(busType.rawValue, forKey: UserDefaultsKeys.timetableBusType)
        }
    }
    
    init() {
        let userDefaults = UserDefaults.standard
        
        let busKey = userDefaults.string(forKey: UserDefaultsKeys.timetableBus)
        self.busLineType = .init(name: busKey ?? "") ?? .schoolBus(.stationToCampus)
        
        let busTypeKey = userDefaults.string(forKey: UserDefaultsKeys.timetableBusType)
        self.busType = .init(rawValue: busTypeKey ?? "") ?? .schoolOmiya
    }
}
