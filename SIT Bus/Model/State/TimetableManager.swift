//
//  TimetableFetcher.swift
//  School Bus
//
//  Created by Yuto on 2024/08/12.
//

import Foundation
import StoreKit

@MainActor
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
    
    private var busStateUpdateTask: Task<Void, Never>?
    private let repository: BusRepository
    private let settings: AppSettings
    private let clock: AppClock
    
    init(
        repository: BusRepository = BusRepository(),
        settings: AppSettings = AppSettings(),
        clock: AppClock = SystemClock()
    ) {
        self.repository = repository
        self.settings = settings
        self.clock = clock
        lastUpdatedDate = settings.lastUpdateDate
        
        Task { [weak self] in
            guard let self else { return }
#if DEBUG
            if ProcessInfo().isSwiftUIPreview {
                do {
                    let previewData = try Data(contentsOf: URL(filePath: Bundle.main.path(forResource: "bus_data", ofType: "json")!))
                    let result = try JSONDecoder().decode(SBReferenceData.self, from: previewData)
                    data = result
                    schoolBusOmiya = result.toBusTimetable()
                } catch {
                    await loadData()
                }
            } else {
                await loadData()
            }
#else
            await loadData()
#endif
            // Start updating bus states in background
            startBusStateUpdates()
        }
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
        let result = await repository.loadData(forceRefresh: forceFetch)
        
        switch result {
        case .success(let loaded):
            data = loaded.data
            schoolBusOmiya = loaded.data.toBusTimetable()
            
            if loaded.source == .remote {
                lastUpdatedDate = clock.now
                if loaded.hadExistingRemoteUpdateBeforeSync {
                    await requestReview()
                }
            }
            
            if let remoteError = loaded.remoteError {
                error = remoteError
                showAlert = true
            }
        case .failure(let failure):
            error = failure
            showAlert = true
        }
        
        updateBusStates()
    }
    
    // MARK: - Private Methods
    private func requestReview() async {
        if settings.hasReviewedAppV1 { return }
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            AppStore.requestReview(in: window)
            settings.hasReviewedAppV1 = true
        }
    }
    
    /// Starts a background task that continuously updates all bus states.
    func startBusStateUpdates() {
        // Cancel existing task if any
        busStateUpdateTask?.cancel()
        
        busStateUpdateTask = Task(priority: .background) { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                self.updateBusStates()
                
                do {
                    let sleepDuration = self.nextRefreshInterval()
                    try await Task.sleep(nanoseconds: UInt64(sleepDuration * 1_000_000_000))
                } catch {
                    break
                }
            }
        }
    }
    
    /// Updates all bus state properties based on current timetable data.
    private func updateBusStates() {
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
    
    private func nextRefreshInterval() -> TimeInterval {
        let now = Date()
        let intervals: [TimeInterval?] = [
            toCampusState.makeTimeInterval(currentTime: now),
            toStationState.makeTimeInterval(currentTime: now),
            toCampusStateIwatsuki.makeTimeInterval(currentTime: now),
            toStationStateIwatsuki.makeTimeInterval(currentTime: now),
            toOmiyaState.makeTimeInterval(currentTime: now),
            toToyosuState.makeTimeInterval(currentTime: now)
        ]
        
        let nextInterval = intervals.compactMap { $0 }.min() ?? 30
        return max(nextInterval, 1)
    }
    
    private func computeNextState(
        timetable: BusTimetable,
        type: BusTimetable.DestinationType,
        now: Date
    ) -> NextBusState {
        if let nextBusDate = timetable.getNext(from: now, type: type) {
            if let note = timetable.getNextNote(from: now, nextDate: nextBusDate, type: type) {
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
