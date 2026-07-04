//
//  NextBusState.swift
//  SIT Bus
//
//  Created by Yuto on 2025/01/03.
//

import Foundation

enum NextBusState: Equatable {
    case loading
    case nextBus(date: Date, departsIn: Int)
    case timely(start: Date, end: Date)
    case busServiceEnded
    case noBusService
    
    func makeTimeInterval(currentTime: Date) -> TimeInterval? {
        switch self {
        case .nextBus(let date, _):
            let calendar = Calendar.current
            let interval = date.timeIntervalSince(currentTime)
            
            if interval >= 3600 {
                var targetDate = currentTime.addingTimeInterval(1)
                targetDate = calendar.date(bySetting: .minute, value: 0, of: targetDate)!
                targetDate = calendar.date(bySetting: .second, value: 0, of: targetDate)!
                return targetDate.timeIntervalSince(currentTime)
            } else {
                var targetDate = currentTime.addingTimeInterval(1)
                targetDate = calendar.date(bySetting: .second, value: 0, of: targetDate)!
                return targetDate.timeIntervalSince(currentTime)
            }
        case .timely(_, let end):
            return end.addingTimeInterval(60).timeIntervalSince(currentTime)
        case .busServiceEnded, .noBusService:
            var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentTime)!
            tomorrow = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) ?? currentTime
            return tomorrow.timeIntervalSince(currentTime)
        case .loading:
            return 10
        }
    }
}
