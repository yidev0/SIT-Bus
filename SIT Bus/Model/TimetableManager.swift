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
    public var lastUpdatedDate: Date = .now
    public var isLoading: Bool = false
    
    private let dataStoreURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yidev.SIT-Bus")?.appendingPathComponent("bus_data", conformingTo: .json)
    
    init() {
        Task {
#if DEBUG
            if ProcessInfo().isSwiftUIPreview {
                print("is preview")
                do {
                    let data = try Data(contentsOf: URL(filePath: Bundle.main.path(forResource: "bus_data", ofType: "json")!))
                    let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
                    self.data = result
                } catch {
                    await loadData()
                }
            } else {
                print("not preview")
                await loadData()
            }
#else
            await loadData()
#endif
        }
    }
    
    public func loadData(forceFetch: Bool = false) async {
        let lastUpdate = UserDefaults.standard.double(forKey: "LastUpdate")
        let lastUpdateDate = Date(timeIntervalSince1970: lastUpdate)
        self.lastUpdatedDate = lastUpdateDate
        
        isLoading = true
        Task {
            if Calendar.current.isDateInToday(lastUpdateDate) == true || forceFetch {
                self.data = await fetchLocalData()
            } else {
                do {
                    self.data = try await fetchData()
                } catch {
                    self.data = await fetchLocalData()
                }
            }
            isLoading = false
        }
    }
    
    private func fetchLocalData() async -> SBReferenceData? {
        if let url = dataStoreURL, FileManager.default.fileExists(atPath: url.path()) {
            do {
                let data = try Data(contentsOf: url)
                let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
                return result
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    private func fetchData() async throws -> SBReferenceData? {
        print("fetching...")
        let fetchURL = URL(string: "http://bus.shibaura-it.ac.jp/db/bus_data.json")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: fetchURL)
            let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
            
            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yidev.SIT-Bus") {
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
