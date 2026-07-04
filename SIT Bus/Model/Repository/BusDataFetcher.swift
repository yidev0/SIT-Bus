//
//  BusDataFetcher.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//

import Foundation

struct BusDataFetcher {
    private static let groupID = "group.com.yidev.SIT-Bus"
    private static let busDataFileName = "bus_data"
    private static let fetchURL = URL(string: "http://bus.shibaura-it.ac.jp/db/bus_data.json")!
    private static let decoder = JSONDecoder()
    
    private var dataStoreURL: URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: Self.groupID)?
            .appendingPathComponent(Self.busDataFileName, conformingTo: .json)
    }
    
    func fetchLocalData() async -> Result<SBReferenceData, BusDataFetcherError>  {
        if let url = dataStoreURL, FileManager.default.fileExists(atPath: url.path()) {
            do {
                let data = try Data(contentsOf: url)
                let result = try Self.decoder.decode(SBReferenceData.self, from: data)
                return .success(result)
            } catch {
                return .failure(.parseError)
            }
        } else {
            return .failure(.noLocalData)
        }
    }
    
    func fetchData() async -> Result<SBReferenceData, BusDataFetcherError> {
        do {
            let (data, response) = try await URLSession.shared.data(from: Self.fetchURL)
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
    
}
