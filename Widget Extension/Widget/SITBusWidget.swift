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
    static var title: LocalizedStringResource = "Label.BusType"
    
    @Parameter(title: "Label.BusType", default: nil)
    var busType: String?
}

struct SITBusWidgetEntry: TimelineEntry {
    var date: Date
    var lineType: BusLineType.SchoolBus
    var time: Date?
    var note: LocalizedStringKey?
}

struct SITBusTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SITBusWidgetEntry {
        .init(date: .now, lineType: .stationToCampus)
    }
    func snapshot(
        for configuration: SITBusWidgetIntent,
        in context: Context
    ) async -> SITBusWidgetEntry {
        return .init(date: .now, lineType: .stationToCampus)
    }
    func timeline(
        for configuration: SITBusWidgetIntent,
        in context: Context
    ) async -> Timeline<SITBusWidgetEntry> {
        let timetableloader = TimetableLoader.shared
        timetableloader.loadTimetable()
        
        let time = timetableloader.data?.getNextBus(for: .campusToStation, date: .now)
        let note = timetableloader.data?.getBusNote(for: .campusToStation, date: .now)
        return .init(
            entries: [.init(
                date: .now,
                lineType: .stationToCampus,
                time: time,
                note: note
            )],
            policy: .atEnd
        )
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
                        .fontWeight(.semibold)
                default:
                    Text(entry.lineType.localizedTitle)
                        .fontWeight(.medium)
                }
                
                Spacer()
            }
            
            Spacer()
            
            if let time = entry.time {
                Text("Label.NextBus")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(time, style: .time)
                    .font(family == .systemSmall ? .title2 : .largeTitle)
                    .fontWeight(.medium)
            } else {
                Text("Label.NoBusService")
            }
        }
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
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
        date: .distantFuture,
        lineType: .stationToCampus
    )
}
