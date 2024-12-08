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
    
    let toToyosu: DepartureDetail = .init(
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
    
    let toOmiya: DepartureDetail = .init(
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
    
    public func getTimesFor(year: Int, month: Int) -> [Date] {
        return activeDates.filter { $0.get(component: .year) == year && $0.get(component: .month) == month }
    }
    
    public func getDepartureTime(for date: Date, type: BusLineType.ShuttleBus) -> (hour: Int, minute: Int) {
        let day = date.get(component: .weekday)
        switch type {
        case .toOmiya:
            let time = toOmiya.time[day]!!.departure
            return (time.hour, time.minute)
        case .toToyosu:
            let time = toToyosu.time[day]!!.departure
            return (time.hour, time.minute)
        }
    }
    
    public func getNextDate(for type: BusLineType.ShuttleBus) -> Date? {
        let today: Date = .now
        var departureTime: (hour: Int, minute: Int)? = nil
        
        switch type {
        case .toToyosu:
            departureTime = toToyosu.time[today.get(component: .weekday)]??.departure
        case .toOmiya:
            departureTime = toOmiya.time[today.get(component: .weekday)]??.departure
        }
        
        if let departureTime, let date: Date = .createDate(
                year: today.get(component: .year),
                month: today.get(component: .month),
                day: today.get(component: .day),
                hour: departureTime.hour,
                minute: departureTime.minute
        ) {
            let futureDates = activeDates.filter { $0 >= date }.sorted()
            return futureDates.first
        } else {
            let futureDates = activeDates.filter { $0 >= .now }.sorted()
            return futureDates.first
        }
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
