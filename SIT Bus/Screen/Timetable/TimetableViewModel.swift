//
//  TimetableViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import Foundation

@MainActor
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
    
    /// The selected route is shared by compact and regular layouts.
    var busLineType: BusLineType {
        didSet {
            settings.timetableBus = busLineType.rawValue
            settings.timetableBusType = busLineType.busType.rawValue
        }
    }
    /// Selecting a different category chooses its first route.
    var busType: BusType {
        get { busLineType.busType }
        set {
            if busLineType.busType != newValue, let route = newValue.cases.first {
                busLineType = route
            }
        }
    }
    
    init(settings: AppSettings = AppSettings()) {
        self.settings = settings
        
        let savedRoute = settings.timetableBus.flatMap(BusLineType.init(name:))
        let savedCategory = settings.timetableBusType.flatMap(BusType.init(rawValue:))
        let route = savedRoute ?? savedCategory?.cases.first ?? .schoolBus(.stationToCampus)
        self.busLineType = route
        settings.timetableBus = route.rawValue
        settings.timetableBusType = route.busType.rawValue
    }
}
