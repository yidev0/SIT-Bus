//
//  HomeViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import Foundation

@Observable
class HomeViewModel {
    
    var showBusSelection = false
    
    func makeTimeTable(for type: BusLineType.SchoolBus, with data: SBReferenceData?) -> [TimetableValue]? {
        return data?.getTimesheet(for: .now)?.makeTimetable(for: type)
    }
}
