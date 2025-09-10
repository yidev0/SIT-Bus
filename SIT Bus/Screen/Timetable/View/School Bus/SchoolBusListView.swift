//
//  TimetableListView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/23.
//

import SwiftUI

struct SchoolBusListView: View {
    
    var timetable: [Int: [BusTimetable.Table.Value]]?
    
    init(table: BusTimetable.Table?, for type: BusTimetable.DestinationType) {
        self.timetable = table?.sectionize(type: type)
    }
    
    var body: some View {
        if let timetable {
            if #available(iOS 26.0, *) {
                makeList(for: timetable)
                    .listSectionIndexVisibility(.visible)
            } else {
                makeList(for: timetable)
            }
        } else {
            ContentUnavailableView(
                "Label.NoBuses",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }
    
    func makeList(for timetable: [Int: [BusTimetable.Table.Value]]) -> some View {
        ScrollViewReader { proxy in
            List {
                ForEach(timetable.keys.sorted(), id: \.self) { hour in
                    if #available(iOS 26.0, *) {
                        makeSection(for: timetable, hour: hour)
                            .sectionIndexLabel("\(hour)")
                    } else {
                        makeSection(for: timetable, hour: hour)
                    }
                }
            }
            .onAppear {
                proxy.scrollTo(Date.now.get(.hour), anchor: .top)
            }
        }
    }
    
    func makeSection(
        for timetable: [Int: [BusTimetable.Table.Value]],
        hour: Int
    ) -> some View {
        Section {
            ForEach(timetable[hour] ?? [], id: \.self) { value in
                if let note = value.note {
                    note.makeText()
                        .id(note)
                }
                Text(value.time.toDate(), style: .time)
                    .monospacedDigit()
                    .id(value)
            }
        } header: {
            Text(hour, format: .number)
        }
    }
}

#Preview {
    SchoolBusListView(
        table: BusTimetable.sample.getTable(for: .now),
        for: .type1
    )
}
