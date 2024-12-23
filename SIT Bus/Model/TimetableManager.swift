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
    public var error: BusDataFetcherError? = nil
    
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
        let lastUpdate = UserDefaults.shared.double(forKey: UserDefaultsKeys.lastUpdateDate)
        let lastUpdateDate = Date(timeIntervalSince1970: lastUpdate)
        
        let dataFetcher = BusDataFetcher()
        Task {
            let fetch = Calendar.current.isDateInToday(lastUpdateDate) == false || forceFetch
            if fetch {
                let response = await dataFetcher.fetchData()
                
                switch response {
                case .success(let success):
                    self.data = success
                    self.lastUpdatedDate = lastUpdateDate
                    UserDefaults.shared.set(Date.now.timeIntervalSince1970, forKey: UserDefaultsKeys.lastUpdateDate)
                case .failure(let failure):
                    error = failure
                }
            }
            
            if self.data == nil {
                let response = await dataFetcher.fetchLocalData()
                switch response {
                case .success(let success):
                    self.data = success
                case .failure(let failure):
                    switch failure {
                    case .noLocalData:
                        // TODO: alert local data
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
    
}

fileprivate extension ProcessInfo {
    var isSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
