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
    var nextBusState: NextBusState
}

struct SITBusTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SITBusWidgetEntry {
        .init(
            date: .now,
            lineType: .stationToCampus,
            nextBusState: .busServiceEnded
        )
    }
    
    func snapshot(
        for configuration: SITBusWidgetIntent,
        in context: Context
    ) async -> SITBusWidgetEntry {
        return .init(
            date: .now,
            lineType: configuration.busType,
            nextBusState: .busServiceEnded
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
        
        let timetable = timetableloader.data?.makeTimetable(
            for: busType,
            date: baseTime
        )
        
        while entries.count < 20 {
            let state = loadNextState(timetable: timetable, type: busType, baseTime: baseTime)
            entries.append(
                .init(
                    date: baseTime,
                    lineType: busType,
                    nextBusState: state
                )
            )
            
            loop: switch state {
            case .nextBus(let date, _):
                baseTime = date.addingTimeInterval(60)
            case .timely(let start, let end):
                baseTime = end.addingTimeInterval(60)
            case .busServiceEnded, .noBusService, .loading:
                break loop
            }
        }
        
        if entries.count <= 1 {
            var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
            tomorrow = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) ?? .now
            
            return .init(
                entries: entries,
                policy: .after(tomorrow)
            )
        }
        
        return .init(entries: entries, policy: .atEnd)
    }
    
    private func loadNextState(timetable: SchoolBusTimetable?, type: BusLineType.SchoolBus, baseTime: Date) -> NextBusState {
        if let nextBusDate = timetable?.getNextBus(for: baseTime) {
            let note = timetable?.getNextBusNote(for: baseTime, nextBusDate: nextBusDate)
            if let note, nextBusDate > note.start {
                return .timely(start: note.start, end: note.end)
            } else {
                return .nextBus(date: nextBusDate, departsIn: 0)
            }
        } else {
            if timetable == nil {
                return .noBusService
            } else {
                return .busServiceEnded
            }
        }
    }
}

struct SITBusWidgetEntryView : View {
    @Environment(\.colorScheme) var colorScheme
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
            .fontWeight(.semibold)
            
            Spacer()
            
            switch entry.nextBusState {
            case .nextBus(let date, _):
                Text("Label.NextBus", tableName: "Widget")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(date, style: .time)
                    .font(family == .systemSmall ? .title2 : .largeTitle)
                    .fontWeight(.medium)
            case .timely(let start, let end):
                Text("Label.TimelyOperation", tableName: "Widget")
                    .font(family == .systemSmall ? .footnote : .body)
                Text("Label.\(Text(start, style: .time))to\(Text(end, style: .time))Service", tableName: "Widget")
                    .font(family == .systemSmall ? .body : .title2)
                    .fontWeight(family == .systemSmall ? .regular : .medium)
            case .busServiceEnded:
                Text("Label.BusServiceEnded")
                    .font(family == .systemSmall ? .body : .title)
            case .noBusService:
                Text("Label.NoBusService")
                    .font(family == .systemSmall ? .body : .title)
            case .loading:
                EmptyView()
            }
        }
        .contentTransition(.numericText())
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [
                    Color.widgetBackground,
                    Color.widgetBackground,
                    Color.accent.opacity(0.03),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
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
        nextBusState: .timely(start: .now, end: .distantFuture)
    )
    
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        nextBusState: .nextBus(date: .now, departsIn: 5)
    )
    
    SITBusWidgetEntry(
        date: .distantFuture,
        lineType: .stationToCampus,
        nextBusState: .noBusService
    )
    
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        nextBusState: .busServiceEnded
    )
}

#Preview(as: .systemMedium) {
    SITBusWidget()
} timeline: {
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        nextBusState: .timely(start: .now, end: .distantFuture)
    )
    
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        nextBusState: .nextBus(date: .now, departsIn: 5)
    )
    
    SITBusWidgetEntry(
        date: .distantFuture,
        lineType: .stationToCampus,
        nextBusState: .noBusService
    )
    
    SITBusWidgetEntry(
        date: .now,
        lineType: .stationToCampus,
        nextBusState: .busServiceEnded
    )
}
