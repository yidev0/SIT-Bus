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
    
    func makeTimetable(from data: SBReferenceData?, date: Date) {
        if let data {
            self.toStationTimetable = data.makeTimetable(for: .campusToStation, date: date)
            self.toCampusTimetable = data.makeTimetable(for: .stationToCampus, date: date)
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
