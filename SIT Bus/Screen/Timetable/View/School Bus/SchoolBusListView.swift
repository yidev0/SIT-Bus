//
//  TimetableListView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/23.
//

import SwiftUI

struct SchoolBusListView: View {
    
    @State var scrollPosition: Int?
    var timetable: [Int: [BusTimetable.Table.Value]]?
    
    init(table: BusTimetable.Table?, for type: BusTimetable.DestinationType) {
        self.timetable = table?.sectionize(type: type)
    }
    
    var body: some View {
        if let timetable {
            List {
                ForEach(timetable.keys.sorted(), id: \.self) { hour in
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(timetable[hour] ?? [], id: \.self) { value in
                                if let note = value.note, let from = note.from?.toDate(), let until = note.until?.toDate() {
                                    Text("Label.\(Text(from, format: .dateTime.hour().minute()))to\(Text(until, format: .dateTime.hour().minute()))Service")
                                }
                                Text(value.time.toDate(), style: .time)
                                    .monospacedDigit()
                            }
                        }
                    } header: {
                        Text(hour, format: .number)
                    }
                }
            }
            .scrollPosition(id: $scrollPosition, anchor: .top)
            .contentMargins(16)
            .onAppear {
                self.scrollPosition = Date.now.get(.hour)
            }
        } else {
            ContentUnavailableView(
                "Label.NoBuses",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }
    
    private func formatHour(hour: Int) -> Date? {
        var components = DateComponents()
        components.hour = hour
        let calendar = Calendar.current
        return calendar.date(from: components)
    }
    
}

#Preview {
    SchoolBusListView(
        table: BusTimetable.schoolBusIwatsuki.getTable(for: .createDate(year: 2025, month: 10, day: 1)!),
        for: .type1
    )
}
