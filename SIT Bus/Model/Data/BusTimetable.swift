//
//  BusTimetable.swift
//  sit-bus
//
//  Created by Yuto on 2025/05/27.
//

import Foundation

class BusTimetable {
    
    let calendar: [Calendar]
    
    private let tables: [Table]
    
    init(
        calendar: [Calendar],
        tables: [Table]
    ) {
        self.calendar = calendar
        self.tables = tables
    }
    
    struct Calendar {
        let date: Date
        let tableName: String
    }
    
    struct Table {
        let name: String
        /// To Campus / To Toyosy
        let destination1: [Value]
        /// To Station / To Omiya
        let destination2: [Value]
        
        struct Value {
            let time: Time
            let note: Note?
            
            init(
                time: Time,
                note: Note? = nil
            ) {
                self.time = time
                self.note = note
            }
            
            struct Time {
                let hour: Int
                let minute: Int
                
                func getSum() -> Int {
                    hour * 60 + minute
                }
            }
            
            struct Note {
                let from: Time?
                let until: Time?
            }
        }
    }
    
    enum DestinationType {
        case type1
        case type2
    }
    
    /// Returns the Date of the next bus after the given date, or nil if not found.
    func getNext(from date: Date, type: DestinationType) -> Date? {
        // Find today's calendar
        let currentCalendar = Foundation.Calendar.current
        guard let calendarEntry = calendar.first(where: { currentCalendar.isDate($0.date, inSameDayAs: date) }) else { return nil }
        guard let table = tables.first(where: { $0.name == calendarEntry.tableName }) else { return nil }
        let timetable: [Table.Value] = switch type {
        case .type1: table.destination1
        case .type2: table.destination2
        }
        let nowComponents = currentCalendar.dateComponents([.hour, .minute], from: date)
        let nowMinutes = (nowComponents.hour ?? 0) * 60 + (nowComponents.minute ?? 0)
        if let next = timetable.first(where: { val in
            let busMinutes = val.time.hour * 60 + val.time.minute
            return busMinutes > nowMinutes
        }) {
            var components = currentCalendar.dateComponents([.year, .month, .day], from: calendarEntry.date)
            components.hour = next.time.hour
            components.minute = next.time.minute
            components.second = 0
            return currentCalendar.date(from: components)
        }
        return nil
    }
    
    /// Returns the start and end Date for the next bus note after 'date' and before 'nextDate', if any.
    func getNextNote(
        from date: Date,
        nextDate: Date = .distantFuture,
        type: DestinationType
    ) -> (startDate: Date, endDate: Date)? {
        let currentCalendar = Foundation.Calendar.current
        guard let calendarEntry = calendar.first(where: { currentCalendar.isDate($0.date, inSameDayAs: date) }) else { return nil }
        guard let table = tables.first(where: { $0.name == calendarEntry.tableName }) else { return nil }
        let timetable: [Table.Value] = switch type {
        case .type1: table.destination1
        case .type2: table.destination2
        }
        let nowComponents = currentCalendar.dateComponents([.hour, .minute], from: date)
        let nowMinutes = (nowComponents.hour ?? 0) * 60 + (nowComponents.minute ?? 0)
        let nextComponents = currentCalendar.dateComponents([.hour, .minute], from: nextDate)
        let nextMinutes = (nextComponents.hour ?? 0) * 60 + (nextComponents.minute ?? 0)
        
        if let value = timetable.first(where: { val in
            let busMinutes = val.time.hour * 60 + val.time.minute
            return busMinutes > nowMinutes && busMinutes < nextMinutes && val.note != nil
        }), let note = value.note {
            var startComponents = currentCalendar.dateComponents([.year, .month, .day], from: calendarEntry.date)
            startComponents.hour = value.time.hour
            startComponents.minute = value.time.minute
            startComponents.second = 0
            guard let startDate = currentCalendar.date(from: startComponents) else { return nil }
            
            var endComponents = currentCalendar.dateComponents([.year, .month, .day], from: calendarEntry.date)
            
            if let until = note.until {
                endComponents.hour = until.hour
                endComponents.minute = until.minute
            } else if let from = note.from {
                // If until is nil but from is not, use from as end time
                endComponents.hour = from.hour
                endComponents.minute = from.minute
            } else {
                // If both from and until are nil, use bus time as end time
                endComponents.hour = value.time.hour
                endComponents.minute = value.time.minute
            }
            endComponents.second = 0
            
            guard let endDate = currentCalendar.date(from: endComponents) else { return nil }
            
            return (startDate, endDate)
        }
        return nil
    }
}

extension BusTimetable {
    static let schoolBusIwatsuki: BusTimetable = .init(
        calendar: [
            // Saturdays
            .init(date: .createDate(year: 2025, month: 9, day: 27)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 4)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 11)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 18)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 25)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 8)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 15)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 22)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 29)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 6)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 13)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 20)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 10)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 24)!, tableName: "Weekend"),
            // Weekdays
            .init(date: .createDate(year: 2025, month: 9, day: 29)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 9, day: 30)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 1)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 2)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 3)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 6)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 7)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 8)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 9)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 10)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 14)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 15)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 16)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 17)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 20)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 21)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 22)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 23)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 24)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 27)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 10, day: 28)!, tableName: "Weekend"),
            
            .init(date: .createDate(year: 2025, month: 11, day: 5)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 6)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 7)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 10)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 11)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 12)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 13)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 14)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 17)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 18)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 19)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 20)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 21)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 25)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 26)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 27)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 11, day: 28)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 1)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 2)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 3)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 4)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 5)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 8)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 9)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 10)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 11)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 12)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 15)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 16)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 17)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 18)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 19)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 22)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2025, month: 12, day: 23)!, tableName: "Weekend"),
            
            .init(date: .createDate(year: 2026, month: 1, day: 7)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 8)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 9)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 13)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 14)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 15)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 16)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 19)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 20)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 21)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 22)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 23)!, tableName: "Weekend"),
            .init(date: .createDate(year: 2026, month: 1, day: 26)!, tableName: "Weekend"),
        ],
        tables: [
            .init(
                name: "Weekday",
                destination1: [
                    .init(time: .init(hour: 7, minute: 45)),
                    .init(time: .init(hour: 8, minute: 25)),
                    .init(time: .init(hour: 9, minute: 5)),
                    .init(time: .init(hour: 10, minute: 20)),
                    .init(time: .init(hour: 12, minute: 50)),
                    .init(time: .init(hour: 13, minute: 30)),
                    .init(time: .init(hour: 15, minute: 35)),
                    .init(time: .init(hour: 16, minute: 15)),
                    .init(time: .init(hour: 17, minute: 35)),
                    .init(time: .init(hour: 19, minute: 10)),
                ],
                destination2: [
                    .init(time: .init(hour: 8, minute: 5)),
                    .init(time: .init(hour: 8, minute: 45)),
                    .init(time: .init(hour: 10, minute: 0)),
                    .init(time: .init(hour: 12, minute: 30)),
                    .init(time: .init(hour: 13, minute: 10)),
                    .init(time: .init(hour: 15, minute: 15)),
                    .init(time: .init(hour: 15, minute: 55)),
                    .init(time: .init(hour: 17, minute: 15)),
                    .init(time: .init(hour: 18, minute: 50)),
                    .init(time: .init(hour: 19, minute: 30)),
                ]
            ),
            .init(
                name: "Weekend",
                destination1: [
                    .init(time: .init(hour: 8, minute: 25)),
                    .init(time: .init(hour: 9, minute: 5)),
                    .init(time: .init(hour: 10, minute: 20)),
                    .init(time: .init(hour: 12, minute: 50)),
                    .init(time: .init(hour: 13, minute: 30)),
                    .init(time: .init(hour: 15, minute: 35)),
                    .init(time: .init(hour: 16, minute: 15)),
                    .init(time: .init(hour: 17, minute: 35)),
                ],
                destination2: [
                    .init(time: .init(hour: 8, minute: 45)),
                    .init(time: .init(hour: 10, minute: 0)),
                    .init(time: .init(hour: 12, minute: 30)),
                    .init(time: .init(hour: 13, minute: 10)),
                    .init(time: .init(hour: 15, minute: 15)),
                    .init(time: .init(hour: 15, minute: 55)),
                    .init(time: .init(hour: 17, minute: 15)),
                    .init(time: .init(hour: 18, minute: 50)),
                ]
            )
        ]
    )
}

