//
//  IwatsukiBusData.swift
//  SIT Bus
//
//  Created by Yuto on 2025/02/22.
//

import Foundation

struct IwatsukiBusData {
    static let lastUpdate = Date.createDate(year: 2024, month: 9, day: 30)!
    
    static let toIwatsuki: SchoolBusTimetable = .init(values: [
        .init(inputDate: .distantPast, hour: 7,  times: [50], note: nil),
        .init(inputDate: .distantPast, hour: 8,  times: [32], note: nil),
        .init(inputDate: .distantPast, hour: 9,  times: [12], note: nil),
        .init(inputDate: .distantPast, hour: 10, times: [20], note: nil),
        .init(inputDate: .distantPast, hour: 11, times: [0],  note: nil),
        .init(inputDate: .distantPast, hour: 12, times: [50], note: nil),
        .init(inputDate: .distantPast, hour: 15, times: [35], note: nil),
        .init(inputDate: .distantPast, hour: 16, times: [15], note: nil),
        .init(inputDate: .distantPast, hour: 17, times: [25], note: nil),
        .init(inputDate: .distantPast, hour: 19, times: [10], note: nil),
    ])
    
    static let toCampus: SchoolBusTimetable = .init(values: [
        .init(inputDate: .distantPast, hour: 7,  times: [30],     note: nil),
        .init(inputDate: .distantPast, hour: 8,  times: [10, 52], note: nil),
        .init(inputDate: .distantPast, hour: 10, times: [0, 40],  note: nil),
        .init(inputDate: .distantPast, hour: 12, times: [30],     note: nil),
        .init(inputDate: .distantPast, hour: 15, times: [15, 55], note: nil),
        .init(inputDate: .distantPast, hour: 17, times: [5],      note: nil),
        .init(inputDate: .distantPast, hour: 18, times: [50],     note: nil),
        .init(inputDate: .distantPast, hour: 19, times: [30],     note: nil),
    ])
}
