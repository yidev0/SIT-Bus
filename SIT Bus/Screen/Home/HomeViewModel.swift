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
    var timetable: [TimetableValue]? = nil
//    var busActivity: Activity<SITBusActivityAttributes>?
    
    func makeTimeTable(for type: BusLineType.SchoolBus, with data: SBReferenceData?) -> [TimetableValue]? {
        return data?.getTimesheet(for: .now)?.makeTimetable(for: type)
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
