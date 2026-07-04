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
    
    enum LoadingState: Equatable {
        case notLoaded
        case loading
        case notAvailable
        case loaded
    }
    
    func loadTimetable() async {
        if loadingState == .loaded, data != nil {
            return
        }
        
        if loadingState == .loading {
            return
        }
        
        let dataFetcher = BusDataFetcher()
        loadingState = .loading
        
        let response = await dataFetcher.fetchLocalData()
        switch response {
        case .success(let success):
            self.data = success
            loadingState = .loaded
        case .failure(let failure):
            print(failure)
            loadingState = .notAvailable
        }
    }
    
}
