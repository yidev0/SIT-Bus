//
//  TimetableContentView.swift
//  SIT Bus
//
//  Created by Yuto on 2025/08/30.
//

import SwiftUI

struct TimetableContentView: View {
    
    var date: Date
    var busType: BusLineType
    var timetable: [Int: [BusTimetable.Table.Value]]?
    
    init(
        table: BusTimetable.Table?,
        for type: BusLineType,
        date: Date
    ) {
        let destinationType = type.destinationType
        self.busType = type
        self.timetable = table?.sectionize(type: destinationType)
        self.date = date
    }
    
    var body: some View {
        if let timetable {
            List {
                Section {
                    switch busType {
                    case .schoolBus:
                        EmptyView()
                    case .schoolBusIwatsuki:
                        switch date.isWeekday {
                        case true:
                            Text("Detail.SchoolBusIwatsukiWeekday")
                        case false:
                            Text("Detail.SchoolBusIwatsukiSaturday")
                        }
                    case .shuttleBus(let type):
                        EmptyView()
                    }
                    
                    ForEach(timetable.keys.sorted(), id: \.self) { key in
                        makeCell(
                            text: "\(key)",
                            values: timetable[key]!
                        )
                    }
                } header: {
                    Label(busType.localizedTitle, systemImage: busType.symbol)
                        .foregroundStyle(Color.primary)
                }
            }
            .listRowSpacing(12)
            .listStyle(InsetGroupedListStyle())
        } else {
            ContentUnavailableView(
                "Label.NoBuses",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }
    
    @ViewBuilder
    func makeCell(
        text: String,
        values: [BusTimetable.Table.Value]
    ) -> some View {
        HStack(spacing: 6) {
            if #available(iOS 26.0, *) {
                TimetableHeader(
                    text: text,
                    radius: 26
                )
                .frame(width: 64)
                .accessibilityLabel("Label.Accessibility.\(text)Time")
            } else {
                TimetableHeader(
                    text: text,
                    radius: 10
                )
                .frame(width: 64)
                .accessibilityLabel("Label.Accessibility.\(text)Time")
            }
            
            LazyVGrid(
                columns: [.init(
                    .adaptive(minimum: 48, maximum: 96),
                    spacing: 8
                )]
            ) {
                ForEach(values, id: \.self) { value in
                    Rectangle()
                        .aspectRatio(1.618, contentMode: .fit)
                        .hidden()
                        .overlay {
                            Text(value.time.minute, format: .number)
                                .accessibilityLabel(Text("\(value.time.hour):\(value.time.minute)"))
                        }
                }
            }
        }
        .listRowInsets(.init())
        
        if let note = values.first(where: { $0.note != nil })?.note {
            note.makeText()
        }
    }
}

#Preview {
    TimetableContentView(
        table: BusTimetable.schoolBusIwatsuki.tables.first!,
        for: .schoolBusIwatsuki(.stationToCampus),
        date: .now
    )
}
