//
//  ShuttleBusData.swift
//  School Bus
//
//  Created by Yuto on 2024/09/23.
//

import Foundation
import SwiftUICore

struct ShuttleBusData {
    let lastUpdate = Date.createDate(year: 2024, month: 9, day: 23)
    
    private let activeDates: [Date] = [
        Date.createDate(year: 2024, month:  9, day: 30)!,
        Date.createDate(year: 2024, month: 10, day: 2)!,
        Date.createDate(year: 2024, month: 10, day: 4)!,
        Date.createDate(year: 2024, month: 10, day: 7)!,
        Date.createDate(year: 2024, month: 10, day: 9)!,
        Date.createDate(year: 2024, month: 10, day: 11)!,
        Date.createDate(year: 2024, month: 10, day: 14)!,
        Date.createDate(year: 2024, month: 10, day: 16)!,
        Date.createDate(year: 2024, month: 10, day: 18)!,
        Date.createDate(year: 2024, month: 10, day: 21)!,
        Date.createDate(year: 2024, month: 10, day: 23)!,
        Date.createDate(year: 2024, month: 10, day: 25)!,
        Date.createDate(year: 2024, month: 10, day: 28)!,
        Date.createDate(year: 2024, month: 10, day: 30)!,
        Date.createDate(year: 2024, month: 11, day: 8)!,
        Date.createDate(year: 2024, month: 11, day: 11)!,
        Date.createDate(year: 2024, month: 11, day: 13)!,
        Date.createDate(year: 2024, month: 11, day: 15)!,
        Date.createDate(year: 2024, month: 11, day: 18)!,
        Date.createDate(year: 2024, month: 11, day: 20)!,
        Date.createDate(year: 2024, month: 11, day: 22)!,
        Date.createDate(year: 2024, month: 11, day: 25)!,
        Date.createDate(year: 2024, month: 11, day: 27)!,
        Date.createDate(year: 2024, month: 11, day: 29)!,
        Date.createDate(year: 2024, month: 12, day: 2)!,
        Date.createDate(year: 2024, month: 12, day: 4)!,
        Date.createDate(year: 2024, month: 12, day: 6)!,
        Date.createDate(year: 2024, month: 12, day: 9)!,
        Date.createDate(year: 2024, month: 12, day: 11)!,
        Date.createDate(year: 2024, month: 12, day: 13)!,
        Date.createDate(year: 2024, month: 12, day: 16)!,
        Date.createDate(year: 2024, month: 12, day: 18)!,
        Date.createDate(year: 2024, month: 12, day: 20)!,
        Date.createDate(year: 2024, month: 12, day: 23)!,
        Date.createDate(year: 2025, month:  1, day: 8)!,
        Date.createDate(year: 2025, month:  1, day: 10)!,
        Date.createDate(year: 2025, month:  1, day: 15)!,
        Date.createDate(year: 2025, month:  1, day: 17)!,
        Date.createDate(year: 2025, month:  1, day: 20)!,
        Date.createDate(year: 2025, month:  1, day: 22)!,
        Date.createDate(year: 2025, month:  1, day: 24)!,
        Date.createDate(year: 2025, month:  1, day: 27)!,
    ]
    
    private let toToyosuDepartureDates: [Date] = [
        Date.createDate(year: 2024, month:  9, day: 30, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 2,  hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 4,  hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 7,  hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 9,  hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 11, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 14, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 16, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 18, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 21, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 23, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 25, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 28, hour: 13)!,
        Date.createDate(year: 2024, month: 10, day: 30, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 8,  hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 11, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 13, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 15, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 18, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 20, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 22, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 25, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 27, hour: 13)!,
        Date.createDate(year: 2024, month: 11, day: 29, hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 2,  hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 4,  hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 6,  hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 9,  hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 11, hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 13, hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 16, hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 18, hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 20, hour: 13)!,
        Date.createDate(year: 2024, month: 12, day: 23, hour: 13)!,
        Date.createDate(year: 2025, month:  1, day: 8,  hour: 13)!,
        Date.createDate(year: 2025, month:  1, day: 10, hour: 13)!,
        Date.createDate(year: 2025, month:  1, day: 15, hour: 13)!,
        Date.createDate(year: 2025, month:  1, day: 17, hour: 13)!,
        Date.createDate(year: 2025, month:  1, day: 20, hour: 13)!,
        Date.createDate(year: 2025, month:  1, day: 22, hour: 13)!,
        Date.createDate(year: 2025, month:  1, day: 24, hour: 13)!,
        Date.createDate(year: 2025, month:  1, day: 27, hour: 13)!,
    ]
    
    private func makeToOmiyaDepartureDates() -> [Date] {
        let calendar = Calendar.current
        return activeDates.map { date in
            if date.get(component: .weekday) == 6 {
                // friday
                calendar.date(bySettingHour: 15, minute: 15, second: 0, of: date)!
            } else {
                // monday, wednesday
                calendar.date(bySettingHour: 17, minute: 5, second: 0, of: date)!
            }
        }
    }
    
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
        let months = Set(activeDates.map({ $0.get(component: .month) }))
        for month in months {
            let key = activeDates.first(where: { $0.get(component: .month) == month })!
            let dates = activeDates.filter({ $0.get(component: .month) == month }).map { $0.get(component: .day) }
            returnValue[key] = dates
        }
        
        return returnValue
    }
    
    public func getMonths() -> [Date] {
        let months = Set(activeDates.map({ $0.get(component: .month) }))
        var dates: [Date] = []
        months.forEach { month in
            dates.append(activeDates.first(where: { $0.get(component: .month) == month })!)
        }
        
        return dates.sorted()
    }
    
    public func getTimesFor(year: Int, month: Int, type: BusLineType.ShuttleBus) -> [Date] {
        var departureDates: [Date] {
            switch type {
            case .toToyosu:
                toToyosuDepartureDates
            case .toOmiya:
                makeToOmiyaDepartureDates()
            }
        }
        
        return departureDates.filter { $0.get(component: .year) == year && $0.get(component: .month) == month }
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
                makeToOmiyaDepartureDates()
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
                makeToOmiyaDepartureDates()
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
