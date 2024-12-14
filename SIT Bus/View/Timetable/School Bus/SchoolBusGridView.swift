//
//  SheetView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/15.
//

import SwiftUI

struct SchoolBusGridView: View {
    
    var timeSheet: [TimetableValue]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(timeSheet, id: \.hour) { timetable in
                    makeNoteLabel(timetable)
                    
                    if timetable.times.isEmpty == false {
                        HStack(spacing: 0) {
                            TimetableHeader(
                                text: String(timetable.hour),
                                radius: 8
                            )
                            .accessibilityLabel(Text("Label.Accessibility.\(timetable.hour)Time"))
                            .frame(width: 52)
                            //
                            LazyVGrid(
                                columns: [.init(
                                    .adaptive(minimum: 48, maximum: 80),
                                    spacing: 8
                                )],
                                spacing: 4
                            ) {
                                ForEach(timetable.times, id: \.self) { time in
                                    SchoolBusGridCell(
                                        hour: timetable.hour,
                                        minute: time.get(component: .minute)
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(4)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(
                                    Color(.secondarySystemGroupedBackground)
                                )
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private func makeNoteLabel(_ timetable: TimetableValue) -> some View {
        if let range1 = timetable.dateRange1,
           let range2 = timetable.dateRange2 {
            Text("Label.\(Text(range1, format: .dateTime.hour().minute()))to\(Text(range2, format: .dateTime.hour().minute()))Service")
                .padding(.vertical, 8)
        } else if let note = timetable.note {
            Text(note)
                .padding(.vertical, 8)
        }
    }
    
}

#Preview {
    SchoolBusGridView(
        timeSheet: []
    )
}
