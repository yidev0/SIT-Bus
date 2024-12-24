//
//  HomeViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import Foundation
import ActivityKit

@Observable
class HomeViewModel {
    
    var showBusSelection = false
    var toCampusTimetable: SchoolBusTimetable? = nil
    var toStationTimetable: SchoolBusTimetable? = nil
//    var busActivity: Activity<SITBusActivityAttributes>?
    
    func makeTimetable(from data: SBReferenceData?) {
        if let data, let timesheet = data.getTimesheet(for: .now) {
            self.toStationTimetable = timesheet.makeTimetable(for: .campusToStation)
            self.toCampusTimetable = timesheet.makeTimetable(for: .stationToCampus)
        } else {
            self.toStationTimetable = nil
            self.toCampusTimetable = nil
        }
    }
    
    func getTimetable(for type: BusLineType.SchoolBus) -> SchoolBusTimetable? {
        switch type {
        case .stationToCampus:
            toCampusTimetable
        case .campusToStation:
            toStationTimetable
        }
    }
    
    func startLiveActivity(for type: BusLineType.SchoolBus) {
//        TODO: Live Activities
//        if ActivityAuthorizationInfo().areActivitiesEnabled {
//            do {
//                busActivity = try Activity<SITBusActivityAttributes>.request(
//                    attributes: .init(busType: .campusToStation),
//                    content: .init(
//                        state: .init(nextBusTime: .now, remainingMinutes: 0),
//                        staleDate: .distantFuture
//                    )
//                )
//            } catch {
//                print(error)
//            }
//        }
    }
}
