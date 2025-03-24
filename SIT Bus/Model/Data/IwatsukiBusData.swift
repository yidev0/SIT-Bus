//
//  IwatsukiBusData.swift
//  SIT Bus
//
//  Created by Yuto on 2025/02/22.
//

import Foundation

struct IwatsukiBusData {
    static let lastUpdateDate = Date.createDate(year: 2025, month: 3, day: 10)!
    
    static let toCampusWeekday: SchoolBusTimetable = .init(values: [
        .init(inputDate: .distantPast, hour: 7,  times: [45], note: nil),
        .init(inputDate: .distantPast, hour: 8,  times: [25], note: nil),
        .init(inputDate: .distantPast, hour: 9,  times: [5], note: nil),
        .init(inputDate: .distantPast, hour: 10, times: [20], note: nil),
        .init(inputDate: .distantPast, hour: 11, times: [],  note: nil),
        .init(inputDate: .distantPast, hour: 12, times: [50], note: nil),
        .init(inputDate: .distantPast, hour: 13, times: [30], note: nil),
        .init(inputDate: .distantPast, hour: 14, times: [], note: nil),
        .init(inputDate: .distantPast, hour: 15, times: [35], note: nil),
        .init(inputDate: .distantPast, hour: 16, times: [15], note: nil),
        .init(inputDate: .distantPast, hour: 17, times: [35], note: nil),
        .init(inputDate: .distantPast, hour: 18, times: [], note: nil),
        .init(inputDate: .distantPast, hour: 19, times: [10], note: nil),
    ])
    
    static let toStationWeekday: SchoolBusTimetable = .init(values: [
        .init(inputDate: .distantPast, hour: 7,  times: [], note: nil),
        .init(inputDate: .distantPast, hour: 8,  times: [5, 45], note: nil),
        .init(inputDate: .distantPast, hour: 9,  times: [], note: nil),
        .init(inputDate: .distantPast, hour: 10, times: [0], note: nil),
        .init(inputDate: .distantPast, hour: 11, times: [],  note: nil),
        .init(inputDate: .distantPast, hour: 12, times: [30], note: nil),
        .init(inputDate: .distantPast, hour: 13, times: [10], note: nil),
        .init(inputDate: .distantPast, hour: 14, times: [], note: nil),
        .init(inputDate: .distantPast, hour: 15, times: [15, 55], note: nil),
        .init(inputDate: .distantPast, hour: 16, times: [], note: nil),
        .init(inputDate: .distantPast, hour: 17, times: [15], note: nil),
        .init(inputDate: .distantPast, hour: 18, times: [50], note: nil),
        .init(inputDate: .distantPast, hour: 19, times: [30], note: nil),
    ])

    static let toCampusSaturday: SchoolBusTimetable = .init(values: [
        .init(inputDate: .distantPast, hour: 7,  times: [], note: nil),
        .init(inputDate: .distantPast, hour: 8,  times: [25], note: nil),
        .init(inputDate: .distantPast, hour: 9,  times: [5], note: nil),
        .init(inputDate: .distantPast, hour: 10, times: [20], note: nil),
        .init(inputDate: .distantPast, hour: 11, times: [],  note: nil),
        .init(inputDate: .distantPast, hour: 12, times: [50], note: nil),
        .init(inputDate: .distantPast, hour: 13, times: [30], note: nil),
        .init(inputDate: .distantPast, hour: 14, times: [], note: nil),
        .init(inputDate: .distantPast, hour: 15, times: [35], note: nil),
        .init(inputDate: .distantPast, hour: 16, times: [15], note: nil),
        .init(inputDate: .distantPast, hour: 17, times: [35], note: nil),
        .init(inputDate: .distantPast, hour: 18, times: [], note: nil),
        .init(inputDate: .distantPast, hour: 19, times: [], note: nil),
    ])
    
    static let toStationSaturday: SchoolBusTimetable = .init(values: [
        .init(inputDate: .distantPast, hour: 7,  times: [], note: nil),
        .init(inputDate: .distantPast, hour: 8,  times: [45], note: nil),
        .init(inputDate: .distantPast, hour: 9,  times: [], note: nil),
        .init(inputDate: .distantPast, hour: 10, times: [0], note: nil),
        .init(inputDate: .distantPast, hour: 11, times: [],  note: nil),
        .init(inputDate: .distantPast, hour: 12, times: [30], note: nil),
        .init(inputDate: .distantPast, hour: 13, times: [10], note: nil),
        .init(inputDate: .distantPast, hour: 14, times: [], note: nil),
        .init(inputDate: .distantPast, hour: 15, times: [15, 55], note: nil),
        .init(inputDate: .distantPast, hour: 16, times: [], note: nil),
        .init(inputDate: .distantPast, hour: 17, times: [15], note: nil),
        .init(inputDate: .distantPast, hour: 18, times: [50], note: nil),
        .init(inputDate: .distantPast, hour: 19, times: [], note: nil),
    ])
    
//    static let toCampus: SchoolBusTimetable = .init(values: [
//        .init(inputDate: .distantPast, hour: 7,  times: [30],     note: nil),
//        .init(inputDate: .distantPast, hour: 8,  times: [10, 52], note: nil),
//        .init(inputDate: .distantPast, hour: 10, times: [0, 40],  note: nil),
//        .init(inputDate: .distantPast, hour: 12, times: [30],     note: nil),
//        .init(inputDate: .distantPast, hour: 15, times: [15, 55], note: nil),
//        .init(inputDate: .distantPast, hour: 17, times: [5],      note: nil),
//        .init(inputDate: .distantPast, hour: 18, times: [50],     note: nil),
//        .init(inputDate: .distantPast, hour: 19, times: [30],     note: nil),
//    ])
//    
//    static let toStation: SchoolBusTimetable = .init(values: [
//        .init(inputDate: .distantPast, hour: 7,  times: [30],     note: nil),
//        .init(inputDate: .distantPast, hour: 8,  times: [10, 52], note: nil),
//        .init(inputDate: .distantPast, hour: 10, times: [0, 40],  note: nil),
//        .init(inputDate: .distantPast, hour: 12, times: [30],     note: nil),
//        .init(inputDate: .distantPast, hour: 15, times: [15, 55], note: nil),
//        .init(inputDate: .distantPast, hour: 17, times: [5],      note: nil),
//        .init(inputDate: .distantPast, hour: 18, times: [50],     note: nil),
//        .init(inputDate: .distantPast, hour: 19, times: [30],     note: nil),
//    ])
}
