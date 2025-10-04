//
//  TimetableFetcher.swift
//  School Bus
//
//  Created by Yuto on 2024/08/12.
//

import Foundation
import StoreKit

@Observable
class TimetableManager {
    
    var data: SBReferenceData? = nil
    var lastUpdatedDate: Date
    
    var showAlert = false
    var error: BusDataFetcherError? = .parseError
    
    var schoolBusOmiya: BusTimetable? = nil {
        didSet {
            schoolBusIwatsuki = BusTimetable.schoolBusIwatsuki(basedOn: schoolBusOmiya?.calendar ?? [])
        }
    }
    var schoolBusIwatsuki: BusTimetable?
    var shuttleBus: BusTimetable = .shuttleBus
    
    var toCampusState: NextBusState = .loading
    var toStationState: NextBusState = .loading
    var toCampusStateIwatsuki: NextBusState = .loading
    var toStationStateIwatsuki: NextBusState = .loading
    var toOmiyaState: NextBusState = .loading
    var toToyosuState: NextBusState = .loading
    
    // MARK: - Private Properties
    
    private var busStateUpdateTask: Task<Void, Never>? = nil
    
    init() {
        let lastUpdate = UserDefaults.shared.double(forKey: UserDefaultsKeys.lastUpdateDate)
        lastUpdatedDate = Date(timeIntervalSince1970: lastUpdate)
        
        Task {
#if DEBUG
            if ProcessInfo().isSwiftUIPreview {
                do {
                    let data = try Data(contentsOf: URL(filePath: Bundle.main.path(forResource: "bus_data", ofType: "json")!))
                    let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
                    self.data = result
                    print("Preview, local data")
                } catch {
                    await loadData()
                    print("Preview, loading data")
                }
            } else {
                print("not preview")
                await loadData()
            }
#else
            await loadData()
#endif
            // Start updating bus states in background
            await startBusStateUpdates()
        }
    }
    
    deinit {
        // Cancel ongoing bus state update task on deinit
        busStateUpdateTask?.cancel()
        busStateUpdateTask = nil
    }
    
    // MARK: - Public Methods
    
    func getBusState(for type: BusLineType) -> NextBusState {
        switch type {
        case .schoolBus(let schoolBus):
            switch schoolBus {
            case .campusToStation:
                toStationState
            case .stationToCampus:
                toCampusState
            }
        case .schoolBusIwatsuki(let bus):
            switch bus {
            case .campusToStation:
                toStationStateIwatsuki
            case .stationToCampus:
                toCampusStateIwatsuki
            }
        case .shuttleBus(let shuttleBus):
            switch shuttleBus {
            case .toOmiya:
                toOmiyaState
            case .toToyosu:
                toToyosuState
            }
        }
    }
    
    func getTable(type: BusLineType, date: Date) -> BusTimetable.Table? {
        switch type {
        case .schoolBus:
            schoolBusOmiya?.getTable(for: date)
        case .schoolBusIwatsuki:
            schoolBusIwatsuki?.getTable(for: date)
        case .shuttleBus:
            shuttleBus.getTable(for: date)
        }
    }
    
    func loadData(forceFetch: Bool = false) async {
        let dataFetcher = BusDataFetcher()
        Task {
            let fetch = Calendar.current.isDateInToday(lastUpdatedDate) == false || forceFetch
            if fetch {
                let response = await dataFetcher.fetchData()
                
                switch response {
                case .success(let success):
                    self.data = success
                    self.schoolBusOmiya = success.toBusTimetable()
                    self.lastUpdatedDate = Date.now
                    
                    if fetch, UserDefaults.shared.value(forKey: UserDefaultsKeys.lastUpdateDate) != nil {
                        await requestReview()
                    }
                    
                    UserDefaults.shared.set(Date.now.timeIntervalSince1970, forKey: UserDefaultsKeys.lastUpdateDate)
                    UserDefaults.shared.synchronize()
                case .failure(let failure):
                    error = failure
                    showAlert = true
                }
            }
            
            if self.data == nil {
                let response = await dataFetcher.fetchLocalData()
                switch response {
                case .success(let success):
                    self.data = success
                    self.schoolBusOmiya = success.toBusTimetable()
                case .failure(let failure):
                    switch failure {
                    case .noLocalData:
                        error = failure
                        showAlert = true
                    default:
                        break
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func requestReview() async {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasReviewedApp) == true { return }
        if let window = await UIApplication.shared.connectedScenes.first as? UIWindowScene {
            await AppStore.requestReview(in: window)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.hasReviewedApp)
        }
    }
    
    /// Starts a background task that continuously updates all bus states.
    @MainActor
    func startBusStateUpdates() async {
        // Cancel existing task if any
        busStateUpdateTask?.cancel()
        
        busStateUpdateTask = Task.detached(priority: .background) { [weak self] in
            guard let self else { return }
            
            while !Task.isCancelled {
                await self.updateBusStates()
                
                // Use NextBusState.makeTimeInterval(currentTime:) to decide the most precise next wake time
                let now = Date()
                let intervals: [TimeInterval?] = [
                    self.toCampusState.makeTimeInterval(currentTime: now),
                    self.toStationState.makeTimeInterval(currentTime: now),
                    self.toCampusStateIwatsuki.makeTimeInterval(currentTime: now),
                    self.toStationStateIwatsuki.makeTimeInterval(currentTime: now),
                    self.toOmiyaState.makeTimeInterval(currentTime: now),
                    self.toToyosuState.makeTimeInterval(currentTime: now)
                ]
                
                let nextInterval = intervals.compactMap { $0 }.min() ?? 30
                let sleepDuration = max(nextInterval, 1)
                
                do {
                    try await Task.sleep(nanoseconds: UInt64(sleepDuration * 1_000_000_000))
                } catch {
                    break
                }
            }
        }
    }
    
    /// Updates all bus state properties based on current timetable data.
    @MainActor
    private func updateBusStates() async {
        let now = Date()
        
        // Omiya
        if let timetable = schoolBusOmiya {
            toCampusState = computeNextState(timetable: timetable, type: .type1, now: now)
            toStationState = computeNextState(timetable: timetable, type: .type2, now: now)
        } else {
            toCampusState = .loading
            toStationState = .loading
        }
        
        // Iwatsuki (always available timetable object)
        if let schoolBusIwatsuki {
            toCampusStateIwatsuki = computeNextState(timetable: schoolBusIwatsuki, type: .type1, now: now)
            toStationStateIwatsuki = computeNextState(timetable: schoolBusIwatsuki, type: .type2, now: now)
        } else {
            toCampusStateIwatsuki = .loading
            toStationStateIwatsuki = .loading
        }
        
        toToyosuState = computeNextState(timetable: shuttleBus, type: .type1, now: now)
        toOmiyaState = computeNextState(timetable: shuttleBus, type: .type2, now: now)
    }
    
    private func computeNextState(
        timetable: BusTimetable,
        type: BusTimetable.DestinationType,
        now: Date
    ) -> NextBusState {
        if let nextBusDate = timetable.getNext(from: now, type: type) {
            if let note = timetable.getNextNote(from: now, nextDate: nextBusDate, type: type),
               note.endDate >= now {
                return .timely(start: note.startDate, end: note.endDate)
            } else {
                let minutes = max(0, Int(ceil(nextBusDate.timeIntervalSince(now) / 60)))
                return .nextBus(date: nextBusDate, departsIn: minutes)
            }
        } else {
            if timetable.isActive(for: now) {
                return .busServiceEnded
            } else {
                return .noBusService
            }
        }
    }
    
}

fileprivate extension ProcessInfo {
    var isSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
