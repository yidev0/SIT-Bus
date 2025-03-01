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
    
    var toCampusState: NextBusState = .loading
    var toStationState: NextBusState = .loading
    var toOmiyaState: NextBusState = .loading
    var toToyosuState: NextBusState = .loading
    
    private var toCampusTimetable: SchoolBusTimetable? = nil
    private var toStationTimetable: SchoolBusTimetable? = nil
    private var shuttleBusData = ShuttleBusData()
    
    private var schoolBusTask: Task<Void, Never>?
    private var shuttleBusTask: Task<Void, Never>?

//    var busActivity: Activity<SITBusActivityAttributes>?
    
    func makeTimetable(from data: SBReferenceData?) {
        if let data {
            let date = getDate()
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
    
    func startTasks() {
        schoolBusTask?.cancel()
        shuttleBusTask?.cancel()
        
        schoolBusTask = Task {
            await loadSchoolBusStates()
        }
        
        shuttleBusTask = Task {
            await loadShuttleBusStates()
        }
    }
    
    func getBusState(for type: any BusLine) -> NextBusState {
        switch type {
        case BusLineType.SchoolBus.stationToCampus:
            return toCampusState
        case BusLineType.SchoolBus.campusToStation:
            return toStationState
        case BusLineType.ShuttleBus.toToyosu:
            return toToyosuState
        case BusLineType.ShuttleBus.toOmiya:
            return toOmiyaState
        default:
            return .loading
        }
    }
    
    private func loadSchoolBusStates() async {
        if Task.isCancelled {
            return
        }
        let baseTime = getDate()
        let nextSchoolBusStates: [NextBusState] = BusLineType.SchoolBus.allCases.map {
            let state = loadNextState(type: $0, baseTime: baseTime)
            switch $0 {
            case .stationToCampus:
                toCampusState = state
            case .campusToStation:
                toStationState = state
            }
            return state
        }
        if await scheduleNextStateUpdate(states: nextSchoolBusStates, compareTo: baseTime) {
            await loadSchoolBusStates()
        }
    }
    
    private func loadShuttleBusStates() async {
        if Task.isCancelled {
            return
        }
        let baseTime = getDate()
        let nextShuttleBusStates: [NextBusState] = BusLineType.ShuttleBus.allCases.map {
            let state = loadNextState(type: $0, baseTime: baseTime)
            if $0 == .toToyosu {
                toToyosuState = state
            } else if $0 == .toOmiya {
                toOmiyaState = state
            }
            return state
        }
        if await scheduleNextStateUpdate(states: nextShuttleBusStates, compareTo: baseTime) {
            await loadShuttleBusStates()
        }
    }
    
    private func loadNextState(type: BusLineType.SchoolBus, baseTime: Date) -> NextBusState {
        let timetable = getTimetable(for: type)
        if let nextBusDate = timetable?.getNextBus(for: baseTime) {
            let note = timetable?.getNextBusNote(for: baseTime, nextBusDate: nextBusDate)
            if let note, nextBusDate > note.start {
                return .timely(start: note.start, end: note.end)
            } else {
                let remainingMinutes = nextBusDate.convertToMinutes() - baseTime.convertToMinutes()
                return .nextBus(date: nextBusDate, departsIn: remainingMinutes)
            }
        } else {
            if timetable == nil {
                return .noBusService
            } else {
                return .busServiceEnded
            }
        }
    }
    
    private func loadNextState(type: BusLineType.ShuttleBus, baseTime: Date) -> NextBusState {
        if let nextBusDate = shuttleBusData.getDepartureDate(for: baseTime, type: type) {
            if baseTime <= nextBusDate {
                let remainingMinutes = nextBusDate.convertToMinutes() - baseTime.convertToMinutes()
                return .nextBus(date: nextBusDate, departsIn: remainingMinutes)
            } else {
                return .busServiceEnded
            }
        } else {
            if shuttleBusData.isActive(baseTime) {
                return .busServiceEnded
            } else {
                return .noBusService
            }
        }
    }
    
    private func scheduleNextStateUpdate(states: [NextBusState], compareTo currentTime: Date) async -> Bool {
        let intervals = states.compactMap { $0.makeTimeInterval(currentTime: currentTime) }
        print(intervals)
        if let interval = intervals.min() {
            do {
                try await Task.sleep(for: .seconds(interval))
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
}

extension HomeViewModel {
    private func getDate() -> Date {
#if DEBUG
        let userdefaults = UserDefaults.shared
        let interval = userdefaults.double(forKey: UserDefaultsKeys.debugDate)
        if interval == 0 {
            return .now
        } else {
            return Date(timeIntervalSince1970: interval)
        }
#else
        return .now
#endif
    }
}
