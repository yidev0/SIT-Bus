//
//  BusDataSource.swift
//  SIT Bus
//
//  Created by Codex on 2026/03/02.
//

import Foundation

protocol BusDataSource {
    func fetchLocalData() async -> Result<SBReferenceData, BusDataFetcherError>
    func fetchRemoteData() async -> Result<SBReferenceData, BusDataFetcherError>
}

extension BusDataFetcher: BusDataSource {
    func fetchRemoteData() async -> Result<SBReferenceData, BusDataFetcherError> {
        await fetchData()
    }
}
