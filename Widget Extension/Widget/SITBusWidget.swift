//
//  SchoolBusWidget.swift
//  Widget Extension
//
//  Created by Yuto on 2024/12/08.
//

import WidgetKit
import AppIntents
import SwiftUI

struct SITBusWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = .init("Label.BusType", table: "Widget")
    
    @Parameter(title: .init("Label.BusType", table: "Widget"), default: .stationToCampus)
    var busType: BusLineType.SchoolBus
}

struct SITBusWidgetEntry: TimelineEntry {
    var date: Date
    var lineType: BusLineType.SchoolBus
    var time: Date?
    var note: LocalizedStringKey?
}

struct SITBusTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SITBusWidgetEntry {
        .init(
            date: .now,
            lineType: .stationToCampus
        )
    }
    
    func snapshot(
        for configuration: SITBusWidgetIntent,
        in context: Context
    ) async -> SITBusWidgetEntry {
        return .init(
            date: .now,
            lineType: configuration.busType
        )
    }
    
    func timeline(
        for configuration: SITBusWidgetIntent,
        in context: Context
    ) async -> Timeline<SITBusWidgetEntry> {
        let timeline: Timeline<SITBusWidgetEntry> = makeTimeline(busType: configuration.busType)
        return timeline
    }
    
    func makeTimeline(busType: BusLineType.SchoolBus) -> Timeline<SITBusWidgetEntry> {
        let timetableloader = TimetableLoader.shared
        timetableloader.loadTimetable()
        
        var entries: [SITBusWidgetEntry] = []
        var baseTime: Date = .now
        var time: Date?
        var note: (start: Date, end: Date)?
        
        while entries.count < 20 {
            print(baseTime)
            time = timetableloader.data?.getNextBus(
                for: busType,
                date: baseTime
            )
            note = timetableloader.data?.getBusNote(
                for: busType,
                date: baseTime
            )
            
            if let note {
                entries.append(
                    .init(
                        date: baseTime,
                        lineType: busType,
                        note: "Label.\(Text(note.start, format: .dateTime.hour().minute()))to\(Text(note.end, format: .dateTime.hour().minute()))Service"
                    )
                )
                baseTime = Calendar.current.date(byAdding: .minute, value: 1, to: note.end) ?? .now
            } else if let time = time {
                entries.append(
                    .init(
                        date: baseTime,
                        lineType: busType,
                        time: time
                    )
                )
                baseTime = Calendar.current.date(byAdding: .minute, value: 1, to: time) ?? .now
            } else {
                entries.append(.init(date: baseTime, lineType: busType))
                break
            }
        }
        
        if entries.count == 1 {
            var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
            tomorrow = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) ?? .now
            
            return .init(
                entries: entries,
                policy: .after(tomorrow)
            )
        }
        
        return .init(entries: entries, policy: .atEnd)
    }
}

struct SITBusWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: SITBusTimelineProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 0) {
                switch family {
                case .systemSmall:
                    Text(entry.lineType.localizedShortTitle)
                default:
                    Text(entry.lineType.localizedTitle)
                }
                
                Spacer()
            }
            .fontWeight(.bold)
            
            Spacer()
            
            if let note = entry.note {
                Text("Label.TimelyOperation", tableName: "Widget")
                    .font(family == .systemSmall ? .footnote : .body)
                Text(note, tableName: "Widget")
                    .font(family == .systemSmall ? .body : .title2)
                    .fontWeight(family == .systemSmall ? .regular : .medium)
            } else if let time = entry.time {
                Text("Label.NextBus", tableName: "Widget")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(time, style: .time)
                    .font(family == .systemSmall ? .title2 : .largeTitle)
                    .fontWeight(.medium)
            } else {
                Text("Label.NoBusService")
                    .font(family == .systemSmall ? .body : .title)
            }
        }
        .contentTransition(.numericText())
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

struct SITBusWidget: Widget {
    let kind: String = "SchoolBusWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            provider: SITBusTimelineProvider()
        ) { entry in
            SITBusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Text("Label.SITBusWidget", tableName: "Widget"))
        .description(Text("Detail.SITBusWidget", tableName: "Widget"))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    SITBusWidget()
} timeline: {
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        time: .now
    )
    
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        time: .distantFuture
    )
    
    SITBusWidgetEntry(
        date: .distantFuture,
        lineType: .stationToCampus
    )
    
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        time: .now,
        note: "Label.\(Text(Date.distantPast, format: .dateTime.hour().minute()))to\(Text(Date.distantFuture, format: .dateTime.hour().minute()))Service"
    )
}

#Preview(as: .systemMedium) {
    SITBusWidget()
} timeline: {
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        time: .now
    )
    
    SITBusWidgetEntry(
        date: .distantFuture,
        lineType: .stationToCampus
    )
    
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        time: .now,
        note: "Label.\(Text(Date.distantPast, format: .dateTime.hour().minute()))to\(Text(Date.distantFuture, format: .dateTime.hour().minute()))Service"
    )
}
