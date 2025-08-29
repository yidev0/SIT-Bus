//
//  ShuttleBusData.swift
//  School Bus
//
//  Created by Yuto on 2024/09/23.
//

import Foundation
import SwiftUI

struct ShuttleBusData {
    static let lastUpdateDate = Date.createDate(year: 2025, month: 2, day: 18)!
    
    private let activeDates: [Date] = [
        // 4
        Date.createDate(year: 2025, month:  4, day: 11)!,
        Date.createDate(year: 2025, month:  4, day: 14)!,
        Date.createDate(year: 2025, month:  4, day: 16)!,
        Date.createDate(year: 2025, month:  4, day: 18)!,
        Date.createDate(year: 2025, month:  4, day: 21)!,
        Date.createDate(year: 2025, month:  4, day: 23)!,
        Date.createDate(year: 2025, month:  4, day: 25)!,
        Date.createDate(year: 2025, month:  4, day: 28)!,
        // 5
        Date.createDate(year: 2025, month:  5, day: 7)!,
        Date.createDate(year: 2025, month:  5, day: 9)!,
        Date.createDate(year: 2025, month:  5, day: 12)!,
        Date.createDate(year: 2025, month:  5, day: 14)!,
        Date.createDate(year: 2025, month:  5, day: 16)!,
        Date.createDate(year: 2025, month:  5, day: 21)!,
        Date.createDate(year: 2025, month:  5, day: 23)!,
        Date.createDate(year: 2025, month:  5, day: 26)!,
        Date.createDate(year: 2025, month:  5, day: 28)!,
        Date.createDate(year: 2025, month:  5, day: 30)!,
        // 6
        Date.createDate(year: 2025, month:  6, day: 2)!,
        Date.createDate(year: 2025, month:  6, day: 4)!,
        Date.createDate(year: 2025, month:  6, day: 6)!,
        Date.createDate(year: 2025, month:  6, day: 9)!,
        Date.createDate(year: 2025, month:  6, day: 11)!,
        Date.createDate(year: 2025, month:  6, day: 13)!,
        Date.createDate(year: 2025, month:  6, day: 16)!,
        Date.createDate(year: 2025, month:  6, day: 18)!,
        Date.createDate(year: 2025, month:  6, day: 20)!,
        Date.createDate(year: 2025, month:  6, day: 23)!,
        Date.createDate(year: 2025, month:  6, day: 25)!,
        Date.createDate(year: 2025, month:  6, day: 27)!,
        Date.createDate(year: 2025, month:  6, day: 30)!,
        // 7
        Date.createDate(year: 2025, month:  7, day: 2)!,
        Date.createDate(year: 2025, month:  7, day: 4)!,
        Date.createDate(year: 2025, month:  7, day: 7)!,
        Date.createDate(year: 2025, month:  7, day: 9)!,
        Date.createDate(year: 2025, month:  7, day: 11)!,
        Date.createDate(year: 2025, month:  7, day: 14)!,
        Date.createDate(year: 2025, month:  7, day: 16)!,
        Date.createDate(year: 2025, month:  7, day: 18)!,
        Date.createDate(year: 2025, month:  7, day: 21)!,
        Date.createDate(year: 2025, month:  7, day: 23)!,
        Date.createDate(year: 2025, month:  7, day: 25)!,
    ]
    
    private let toToyosuDepartureDates: [Date] = [
        // 4
        Date.createDate(year: 2025, month:  4, day: 11, hour: 13)!,
        Date.createDate(year: 2025, month:  4, day: 14, hour: 13)!,
        Date.createDate(year: 2025, month:  4, day: 16, hour: 13)!,
        Date.createDate(year: 2025, month:  4, day: 18, hour: 13)!,
        Date.createDate(year: 2025, month:  4, day: 21, hour: 13)!,
        Date.createDate(year: 2025, month:  4, day: 23, hour: 13)!,
        Date.createDate(year: 2025, month:  4, day: 25, hour: 13)!,
        Date.createDate(year: 2025, month:  4, day: 28, hour: 13)!,
        // 5
        Date.createDate(year: 2025, month:  5, day: 7,  hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 9,  hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 12, hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 14, hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 16, hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 21, hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 23, hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 26, hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 28, hour: 13)!,
        Date.createDate(year: 2025, month:  5, day: 30, hour: 13)!,
        // 6
        Date.createDate(year: 2025, month:  6, day: 2,  hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 4,  hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 6,  hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 9,  hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 11, hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 13, hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 16, hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 18, hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 20, hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 23, hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 25, hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 27, hour: 13)!,
        Date.createDate(year: 2025, month:  6, day: 30, hour: 13)!,
        // 7
        Date.createDate(year: 2025, month:  7, day: 2,  hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 4,  hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 7,  hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 9,  hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 11, hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 14, hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 16, hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 18, hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 21, hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 23, hour: 13)!,
        Date.createDate(year: 2025, month:  7, day: 25, hour: 13)!,
    ]
    
    private let toOmiyaDepartureDates: [Date] = [
        // 4
        Date.createDate(year: 2025, month:  4, day: 11, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  4, day: 14, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  4, day: 16, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  4, day: 18, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  4, day: 21, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  4, day: 23, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  4, day: 25, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  4, day: 28, hour: 17, minute: 5)!,
        // 5
        Date.createDate(year: 2025, month:  5, day: 7,  hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  5, day: 9,  hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  5, day: 12, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  5, day: 14, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  5, day: 16, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  5, day: 21, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  5, day: 23, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  5, day: 26, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  5, day: 28, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  5, day: 30, hour: 15, minute: 15)!,
        // 6
        Date.createDate(year: 2025, month:  6, day: 2,  hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  6, day: 4,  hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  6, day: 6,  hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  6, day: 9,  hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  6, day: 11, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  6, day: 13, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  6, day: 16, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  6, day: 18, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  6, day: 20, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  6, day: 23, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  6, day: 25, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  6, day: 27, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  6, day: 30, hour: 17, minute: 5)!,
        // 7
        Date.createDate(year: 2025, month:  7, day: 2,  hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  7, day: 4,  hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  7, day: 7,  hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  7, day: 9,  hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  7, day: 11, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  7, day: 14, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  7, day: 16, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  7, day: 18, hour: 15, minute: 15)!,
        Date.createDate(year: 2025, month:  7, day: 21, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  7, day: 23, hour: 17, minute: 5)!,
        Date.createDate(year: 2025, month:  7, day: 25, hour: 15, minute: 15)!,
    ]
    
    private let toToyosu: DepartureDetail = .init(
        location: "",
        time: [
            1: nil,
            2: .init(
                departure: (13, 0),
                arrival: (14, 30)
            ),
            3: nil,
            4: .init(
                departure: (13, 0),
                arrival: (14, 30)
            ),
            5: nil,
            6: .init(
                departure: (13, 0),
                arrival: (14, 30)
            ),
            7: nil,
        ]
    )
    
    private let toOmiya: DepartureDetail = .init(
        location: "",
        time: [
            1: nil,
            2: .init(
                departure: (17, 5),
                arrival: (18, 40)
            ),
            3: nil,
            4: .init(
                departure: (17, 5),
                arrival: (18, 40)
            ),
            5: nil,
            6: .init(
                departure: (15, 15),
                arrival: (16, 55)
            ),
            7: nil,
        ]
    )
    
    public func makeTable() -> [Date: [Int]] {
        var returnValue = [Date: [Int]]()
        let months = Set(activeDates.map({ $0.get(.month) }))
        for month in months {
            let key = activeDates.first(where: { $0.get(.month) == month })!
            let dates = activeDates.filter({ $0.get(.month) == month }).map { $0.get(.day) }
            returnValue[key] = dates
        }
        
        return returnValue
    }
    
    public func getMonths() -> [Date] {
        let months = Set(activeDates.map({ $0.get(.month) }))
        var dates: [Date] = []
        months.forEach { month in
            dates.append(activeDates.first(where: { $0.get(.month) == month })!)
        }
        
        return dates.sorted()
    }
    
    public func getTimesFor(year: Int, month: Int, type: BusLineType.ShuttleBus) -> [Date] {
        var departureDates: [Date] {
            switch type {
            case .toToyosu:
                toToyosuDepartureDates
            case .toOmiya:
                toOmiyaDepartureDates
            }
        }
        
        return departureDates.filter { $0.get(.year) == year && $0.get(.month) == month }
    }
    
    public func getDepartureTime(for weekday: Int, date: Date, type: BusLineType.ShuttleBus) -> Date {
        var departureDetail: DepartureDetail {
            switch type {
            case .toToyosu:
                toToyosu
            case .toOmiya:
                toOmiya
            }
        }
        
        let time = departureDetail.time[weekday]!!.departure
        let calendar = Calendar.current
        return calendar.date(bySettingHour: time.hour, minute: time.minute, second: 0, of: date)!
    }
    
    public func getDepartureDate(for date: Date, type: BusLineType.ShuttleBus) -> Date? {
        var departureDates: [Date] {
            switch type {
            case .toToyosu:
                toToyosuDepartureDates
            case .toOmiya:
                toOmiyaDepartureDates
            }
        }
        
        let calendar = Calendar.current
        if let date = departureDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return date
        } else {
            return nil
        }
    }
    
    public func getNextDate(for type: BusLineType.ShuttleBus, from inpuDate: Date) -> Date? {
        var departureDates: [Date] {
            switch type {
            case .toToyosu:
                toToyosuDepartureDates
            case .toOmiya:
                toOmiyaDepartureDates
            }
        }
        
        let calendar = Calendar.current
        return departureDates.first { date in
            if calendar.isDate(date, inSameDayAs: inpuDate) == true || date > inpuDate {
                true
            } else {
                false
            }
        }
    }
    
    public func isActive(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return activeDates.contains(where: { calendar.isDate($0, inSameDayAs: date) })
    }
    
}

extension ShuttleBusData {
    struct DepartureDetail {
        let location: LocalizedStringKey
        let time: [Int: BusTime?]
        
        struct BusTime {
            let departure: (hour: Int, minute: Int)
            let arrival: (hour: Int, minute: Int)
        }
    }
}
