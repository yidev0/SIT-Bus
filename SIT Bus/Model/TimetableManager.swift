//
//  TimetableFetcher.swift
//  School Bus
//
//  Created by Yuto on 2024/08/12.
//

import Foundation

@Observable
class TimetableManager {
    
    public var data: SBReferenceData? = nil
    public var urlTask: URLSessionTask?
    public var lastUpdatedDate: Date = .now
    
    private let dataStoreURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("bus_data", conformingTo: .json)
    
    init() {
#if DEBUG
        if ProcessInfo().isSwiftUIPreview {
            print("is preview")
            do {
                let data = try Data(contentsOf: URL(filePath: Bundle.main.path(forResource: "bus_data", ofType: "json")!))
                let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
                self.data = result
            } catch {
                loadData()
            }
        } else {
            print("not preview")
            loadData()
        }
#else
        loadData()
#endif
    }
    
    public func loadData(forceFetch: Bool = false) {
        let lastUpdate = UserDefaults.standard.double(forKey: "LastUpdate")
        let lastUpdateDate = Date(timeIntervalSince1970: lastUpdate)
        self.lastUpdatedDate = lastUpdateDate
        
        if Calendar.current.isDateInToday(lastUpdateDate) == true || forceFetch,
           let url = dataStoreURL, FileManager.default.fileExists(atPath: url.path()) {
            do {
                let data = try Data(contentsOf: url)
                let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
                self.data = result
            } catch {
                print(error)
            }
        } else {
            Task {
                do {
                    self.data = try await fetchData()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func fetchData() async throws -> SBReferenceData? {
        print("fetching...")
        let fetchURL = URL(string: "http://bus.shibaura-it.ac.jp/db/bus_data.json")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: fetchURL)
            let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
            
            if let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
                try data.write(to: url.appendingPathComponent("bus_data", conformingTo: .json))
                UserDefaults.standard.set(Date.now.timeIntervalSince1970, forKey: "LastUpdate")
            }
            
            return result
        } catch {
            throw error
        }
    }
    
}

fileprivate extension ProcessInfo {
    var isSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
