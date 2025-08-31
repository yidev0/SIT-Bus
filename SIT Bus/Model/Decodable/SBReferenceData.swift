//
//  SBReferenceData.swift
//  School Bus
//
//  Created by Yuto on 2024/08/13.
//

import Foundation
import SwiftUI

struct SBReferenceData: Decodable, Equatable {
    static func == (lhs: SBReferenceData, rhs: SBReferenceData) -> Bool {
        lhs.update == rhs.update
    }
    
    let update: String
    let timesheet: [SBTimeSheet]
    let calendar: [SBCalendar]
    let siteInfo: [SBSiteInfo]
    
    private enum CodingKeys: String, CodingKey {
        case update
        case timesheet
        case calendar
        case siteInfo = "site_info"
    }
    
    private static let noteDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo") // JST (UTC+9)
        return formatter
    }()
    
    private static let noteRegex: NSRegularExpression = try! NSRegularExpression(pattern: "\\d{1,2}:\\d{2}")
    
    public func getActiveDays() -> [[Date]] {
        var dates: [[Date]] = []
        for calendar in self.calendar {
            dates.append(calendar.getActiveDates())
        }
        
        return dates
    }
    
    func toBusTimetable() -> BusTimetable {
        var calendarEntries: [BusTimetable.Calendar] = []
        for monthCalendar in self.calendar {
            let year = Int(monthCalendar.year) ?? 0
            let month = Int(monthCalendar.month) ?? 0
            for entry in monthCalendar.list {
                guard let day = Int(entry.day), let date = Date.createDate(year: year, month: month, day: day) else { continue }
                if let timesheet = self.timesheet.first(where: { $0.ts_id == entry.ts_id }) {
                    calendarEntries.append(.init(date: date, tableName: timesheet.title, comment: entry.comment))
                }
            }
        }
        
        func parseDestination(_ getValue: @escaping (SBTimeSheet.List) -> SBTimeSheet.List.Value, sheet: SBTimeSheet) -> [BusTimetable.Table.Value] {
            var result: [BusTimetable.Table.Value] = []
            var lastNote: String? = nil
            for list in sheet.list {
                guard let hour = Int(list.time) else { continue }
                let value = getValue(list)
                let times = value.getTimes()
                var note = value.getNotes()
                var dateRange: BusTimetable.Table.Value.Note? = nil
                
                switch (note?.contains("より") == true, note?.contains("まで") == true, lastNote?.isEmpty) {
                case (true, false, nil):
                    lastNote = note
                    note = nil
                case (false, true, false):
                    note = (lastNote?.extractTime() ?? "") + "より" + (note ?? "")
                    lastNote = nil
                default:
                    if note == "適時運行" && lastNote?.contains("より") == true {
                        note = nil
                    } else if note == "適時運行" {
                        lastNote = "\(hour):00"
                        note = nil
                    } else {
                        lastNote = nil
                    }
                }
                // Date range extraction
                if let note, !note.isEmpty {
                    // Use static DateFormatter and NSRegularExpression to improve performance and avoid repeated initialization
                    let matches = SBReferenceData.noteRegex.matches(in: note, range: NSRange(note.startIndex..., in: note))
                    // Safely unwrap first and last match; if unavailable, skip dateRange extraction
                    if matches.count == 2,
                       let firstRange = Range(matches.first?.range ?? NSRange(location: NSNotFound, length: 0), in: note),
                       let lastRange = Range(matches.last?.range ?? NSRange(location: NSNotFound, length: 0), in: note),
                       firstRange.lowerBound != firstRange.upperBound,
                       lastRange.lowerBound != lastRange.upperBound {
                        if let firstDate = SBReferenceData.noteDateFormatter.date(from: String(note[firstRange])),
                           let lastDate = SBReferenceData.noteDateFormatter.date(from: String(note[lastRange])) {
                            dateRange = .init(
                                from: .init(hour: firstDate.get(.hour), minute: firstDate.get(.minute)),
                                until: .init(hour: lastDate.get(.hour), minute: lastDate.get(.minute))
                            )
                        }
                    }
                }
                // Output values
                for minute in times {
                    var note: BusTimetable.Table.Value.Note? = nil
                    if let time = dateRange?.until, time.getSum() < hour * 60 + minute {
                        note = dateRange
                        dateRange = nil
                    }
//                    } else if let time = dateRange?.from, time.getSum() > hour * 60 + minute {
//                        note = dateRange
//                        dateRange = nil
//                    }
                    
                    result.append(BusTimetable.Table.Value(
                        time: .init(hour: hour, minute: minute),
                        note: note
                    ))
                }
            }
            return result
        }

        let tables: [BusTimetable.Table] = timesheet.map { sheet in
            BusTimetable.Table(
                name: sheet.title,
                destination1: parseDestination({ $0.campus }, sheet: sheet),
                destination2: parseDestination({ $0.station }, sheet: sheet)
            )
        }
        
        let updateDate = SBReferenceData.dateFormatter.date(from: update)

        return BusTimetable(calendar: calendarEntries, tables: tables, lastUpdated: updateDate)
    }
    
}
