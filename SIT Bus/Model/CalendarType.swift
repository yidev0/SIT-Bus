//
//  CalendarType.swift
//  SIT Bus
//
//  Created by Yuto on 2025/02/26.
//

enum CalendarType {
    case weekday
    case weekdayHoliday
    case weekdayVacation
    case saturday
    case exam
    case other
    
    var symbol: String {
        switch self {
        case .weekday:
            "circle.fill"
        case .weekdayHoliday:
            "circle"
        case .weekdayVacation:
            "capsule"
        case .saturday:
            "square.fill"
        case .exam:
            "pencil"
        case .other:
            "seal"
        }
    }
}
