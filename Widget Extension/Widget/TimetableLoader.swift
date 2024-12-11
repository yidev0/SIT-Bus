//
//  TimetableLoader.swift
//  School Bus
//
//  Created by Yuto on 2024/12/08.
//

import Foundation

class TimetableLoader {
    
    static let shared = TimetableLoader()
    
    var loadingState: LoadingState = .notLoaded
    var data: SBReferenceData? = nil
    
    enum LoadingState {
        case notLoaded
        case loading
        case notAvailable
        case loaded
    }
    
    func loadTimetable() {
        loadingState = .loading
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yidev.SIT-Bus")?.appendingPathComponent("bus_data", conformingTo: .json)
        if let fileURL, FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                let data = try Data(contentsOf: fileURL)
                let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
                self.data = result
                loadingState = .loaded
            } catch {
                print(error)
            }
        } else {
            loadingState = .notAvailable
        }
    }
    
}
