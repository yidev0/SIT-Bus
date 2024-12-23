//
//  BusDataFetcher.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//

import Foundation

struct BusDataFetcher {
    
    func fetchLocalData() async -> Result<SBReferenceData, BusDataFetcherError>  {
        let dataStoreURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yidev.SIT-Bus")?.appendingPathComponent("bus_data", conformingTo: .json)
        if let url = dataStoreURL, FileManager.default.fileExists(atPath: url.path()) {
            do {
                let data = try Data(contentsOf: url)
                let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
                return .success(result)
            } catch {
                return .failure(.parseError)
            }
        } else {
            return .failure(.noLocalData)
        }
    }
    
    func fetchData() async -> Result<SBReferenceData, BusDataFetcherError> {
        print("fetching...")
        let fetchURL = URL(string: "http://bus.shibaura-it.ac.jp/db/bus_data.json")!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: fetchURL)
            guard let httpURLResponse = response as? HTTPURLResponse else {
                preconditionFailure()
            }
            
            switch httpURLResponse.statusCode {
            case 200...299:
                let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
                if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yidev.SIT-Bus") {
                    try data.write(to: url.appendingPathComponent("bus_data", conformingTo: .json))
                    UserDefaults.standard.set(Date.now.timeIntervalSince1970, forKey: "LastUpdate")
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
