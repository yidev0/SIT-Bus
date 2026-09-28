//
//  BusDataFetcher.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//

import Foundation

struct BusDataFetcher {
    enum Route: Hashable {
        case omiya
        case iwatsuki

        var url: URL {
            switch self {
            case .omiya:
                URL(string: "http://bus.shibaura-it.ac.jp/db/bus_data.json")!
            case .iwatsuki:
                URL(string: "http://bus.shibaura-it.ac.jp/iwatsuki/db/bus_data.json")!
            }
        }

        var cacheFileName: String {
            switch self {
            case .omiya: "bus_data"
            case .iwatsuki: "iwatsuki_bus_data"
            }
        }

        var fallbackFileName: String {
            switch self {
            case .omiya: "fallback_bus_data"
            case .iwatsuki: "fallback_iwatsuki_bus_data"
            }
        }
    }

    private static let groupID = "group.com.yidev.SIT-Bus"
    private static let decoder = JSONDecoder()

    let route: Route

    init(route: Route = .omiya) {
        self.route = route
    }

    private var dataStoreURL: URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: Self.groupID)?
            .appendingPathComponent(route.cacheFileName, conformingTo: .json)
    }
    
    func fetchLocalData() async -> Result<SBReferenceData, BusDataFetcherError>  {
        if let url = dataStoreURL, FileManager.default.fileExists(atPath: url.path()) {
            do {
                let data = try Data(contentsOf: url)
                let result = try Self.decoder.decode(SBReferenceData.self, from: data)
                return .success(result)
            } catch {
                return fetchBundledFallbackData()
            }
        } else {
            return fetchBundledFallbackData()
        }
    }
    private func fetchBundledFallbackData() -> Result<SBReferenceData, BusDataFetcherError> {
        guard let url = Bundle.main.url(forResource: route.fallbackFileName, withExtension: "json") else {
            return .failure(.noLocalData)
        }

        do {
            let data = try Data(contentsOf: url)
            let result = try Self.decoder.decode(SBReferenceData.self, from: data)
            return .success(result)
        } catch {
            return .failure(.parseError)
        }
    }
    
    func fetchData(timeout: TimeInterval? = nil) async -> Result<SBReferenceData, BusDataFetcherError> {
        do {
            var request = URLRequest(url: route.url)
            if let timeout {
                request.timeoutInterval = max(timeout, 0.1)
            }
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpURLResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            switch httpURLResponse.statusCode {
            case 200...299:
                let result = try Self.decoder.decode(SBReferenceData.self, from: data)
                if let url = dataStoreURL {
                    try data.write(to: url)
                }
                return .success(result)
            case 400...499:
                return .failure(.clientError)
            case 500...599:
                return .failure(.serverError)
            default:
                return .failure(.undefined(statusCode: httpURLResponse.statusCode))
            }
        } catch let error as NSError where error.domain == NSURLErrorDomain {
            return .failure(.networkError)
        } catch {
            return .failure(.invalidResponse)
        }
    }

    /// Attempts a short remote refresh, then falls back to the local snapshot captured first.
    func fetchFreshData(remoteTimeout: TimeInterval) async -> Result<SBReferenceData, BusDataFetcherError> {
        let localResult = await fetchLocalData()

        switch await fetchData(timeout: remoteTimeout) {
        case .success(let data):
            return .success(data)
        case .failure(let remoteError):
            switch localResult {
            case .success(let data):
                return .success(data)
            case .failure:
                return .failure(remoteError)
            }
        }
    }
    
}
