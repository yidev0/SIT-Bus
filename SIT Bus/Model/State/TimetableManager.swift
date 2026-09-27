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
    var lastOmiyaFetchDate: Date?
    var lastIwatsukiFetchDate: Date?
    
    var showAlert = false
    var error: BusDataFetcherError? = .parseError
    
    var schoolBusOmiya: BusTimetable? = nil
    var schoolBusIwatsuki: BusTimetable?
    var shuttleBus: BusTimetable = .shuttleBus
    
    var toCampusState: NextBusState = .loading
    var toStationState: NextBusState = .loading
    var toCampusStateIwatsuki: NextBusState = .loading
    var toStationStateIwatsuki: NextBusState = .loading
    var toOmiyaState: NextBusState = .loading
    var toToyosuState: NextBusState = .loading

    var needsRefresh: Bool {
        repository.shouldRefresh(force: false) || iwatsukiRepository.shouldRefresh(force: false)
    }
    
    // MARK: - Private Properties
    
    private var busStateUpdateTask: Task<Void, Never>?
    private let repository: BusRepository
    private let iwatsukiRepository: BusRepository
    private let settings: AppSettings
    
    init(
        repository: BusRepository = BusRepository(),
        iwatsukiRepository: BusRepository = BusRepository(route: .iwatsuki),
        settings: AppSettings = AppSettings()
    ) {
        self.repository = repository
        self.iwatsukiRepository = iwatsukiRepository
        self.settings = settings
        lastOmiyaFetchDate = repository.lastSuccessfulFetchDate
        lastIwatsukiFetchDate = iwatsukiRepository.lastSuccessfulFetchDate
        
        Task { [weak self] in
            guard let self else { return }
#if DEBUG
            if ProcessInfo().isSwiftUIPreview {
                do {
                    let previewData = try Data(contentsOf: URL(filePath: Bundle.main.path(forResource: "bus_data", ofType: "json")!))
                    let result = try JSONDecoder().decode(SBReferenceData.self, from: previewData)
                    data = result
                    schoolBusOmiya = result.toBusTimetable()
                    let iwatsukiURL = Bundle.main.url(forResource: "fallback_iwatsuki_bus_data", withExtension: "json")!
                    let iwatsukiData = try Data(contentsOf: iwatsukiURL)
                    let iwatsukiResult = try JSONDecoder().decode(SBReferenceData.self, from: iwatsukiData)
                    schoolBusIwatsuki = iwatsukiResult.toBusTimetable(source: BusDataFetcher.Route.iwatsuki.url)
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
        let omiyaResult = await repository.loadData(forceRefresh: forceFetch)
        
        switch omiyaResult {
        case .success(let loaded):
            data = loaded.data
            schoolBusOmiya = loaded.data.toBusTimetable()
            
            if loaded.source == .remote {
                lastOmiyaFetchDate = repository.lastSuccessfulFetchDate
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

        let iwatsukiResult = await iwatsukiRepository.loadData(forceRefresh: forceFetch)
        switch iwatsukiResult {
        case .success(let loaded):
            schoolBusIwatsuki = loaded.data.toBusTimetable(source: BusDataFetcher.Route.iwatsuki.url)
            if loaded.source == .remote {
                lastIwatsukiFetchDate = iwatsukiRepository.lastSuccessfulFetchDate
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
        
        // Iwatsuki
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
