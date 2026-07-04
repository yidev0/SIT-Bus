//
//  BusRepository.swift
//  SIT Bus
//
//  Created by Codex on 2026/03/02.
//

import Foundation

struct BusRepository {
    enum Source {
        case remote
        case local
    }
    
    struct LoadResult {
        let data: SBReferenceData
        let source: Source
        let hadExistingRemoteUpdateBeforeSync: Bool
        let remoteError: BusDataFetcherError?
    }
    
    let dataSource: BusDataSource
    let settings: AppSettings
    let clock: AppClock
    
    init(
        dataSource: BusDataSource = BusDataFetcher(),
        settings: AppSettings = AppSettings(),
        clock: AppClock = SystemClock()
    ) {
        self.dataSource = dataSource
        self.settings = settings
        self.clock = clock
    }
    
    func shouldRefresh(force: Bool) -> Bool {
        force || !Calendar.current.isDateInToday(settings.lastUpdateDate)
    }
    
    func fetchRemote() async -> Result<SBReferenceData, BusDataFetcherError> {
        await dataSource.fetchRemoteData()
    }
    
    func fetchLocal() async -> Result<SBReferenceData, BusDataFetcherError> {
        await dataSource.fetchLocalData()
    }
    
    func markUpdatedNow() {
        settings.lastUpdateDate = clock.now
    }
    
    func loadData(forceRefresh: Bool) async -> Result<LoadResult, BusDataFetcherError> {
        let shouldFetchRemote = shouldRefresh(force: forceRefresh)
        let hadExistingRemoteUpdate = settings.hasExistingLastUpdateDate
        var remoteError: BusDataFetcherError?
        
        if shouldFetchRemote {
            switch await fetchRemote() {
            case .success(let data):
                markUpdatedNow()
                return .success(
                    .init(
                        data: data,
                        source: .remote,
                        hadExistingRemoteUpdateBeforeSync: hadExistingRemoteUpdate,
                        remoteError: nil
                    )
                )
            case .failure(let failure):
                remoteError = failure
            }
        }
        
        switch await fetchLocal() {
        case .success(let data):
            return .success(
                .init(
                    data: data,
                    source: .local,
                    hadExistingRemoteUpdateBeforeSync: false,
                    remoteError: remoteError
                )
            )
        case .failure(let failure):
            return .failure(remoteError ?? failure)
        }
    }
}
