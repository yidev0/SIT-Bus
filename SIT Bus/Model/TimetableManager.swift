//
//  TimetableFetcher.swift
//  School Bus
//
//  Created by Yuto on 2024/08/12.
//

import Foundation
import StoreKit

@Observable
class TimetableManager {
    
    public var data: SBReferenceData? = nil
    public var lastUpdatedDate: Date = .now
    
    public var showAlert = false
    public var error: BusDataFetcherError? = .parseError
    
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
        lastUpdatedDate = Date(timeIntervalSince1970: lastUpdate)
        
        let dataFetcher = BusDataFetcher()
        Task {
            let fetch = Calendar.current.isDateInToday(lastUpdatedDate) == false || forceFetch
            if fetch {
                let response = await dataFetcher.fetchData()
                
                switch response {
                case .success(let success):
                    self.data = success
                    self.lastUpdatedDate = Date.now
                    
                    if fetch, lastUpdate != 0 {
                        await requestReview()
                    }
                    
                    UserDefaults.shared.set(Date.now.timeIntervalSince1970, forKey: UserDefaultsKeys.lastUpdateDate)
                    UserDefaults.shared.synchronize()
                case .failure(let failure):
                    error = failure
                    showAlert = true
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
                        error = failure
                        showAlert = true
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func requestReview() async {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasReviewedApp) == true { return }
        if let window = await UIApplication.shared.connectedScenes.first as? UIWindowScene {
            await AppStore.requestReview(in: window)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.hasReviewedApp)
        }
    }
    
}

fileprivate extension ProcessInfo {
    var isSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
