//
//  ContentView.swift
//  SIT Bus Clip
//
//  Created by Yuto on 2026/08/01.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var store = ClipTimetableStore()

    var body: some View {
        TabView {
            ClipHomeView(store: store)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ClipTimetableView(store: store)
                .tabItem {
                    Label("Timetable", systemImage: "tablecells.fill")
                }
        }
        .task {
            await store.load()
        }
    }
}

private struct ClipHomeView: View {
    let store: ClipTimetableStore

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 60)) { context in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if let timetable = store.timetable(for: context.date) {
                            Text(timetable.serviceName)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 4)

                            ClipNextBusCard(
                                title: "Station to Campus",
                                systemImage: "bus.fill",
                                nextBus: timetable.nextBus(for: .stationToCampus, from: context.date),
                                now: context.date
                            )

                            ClipNextBusCard(
                                title: "Campus to Station",
                                systemImage: "bus",
                                nextBus: timetable.nextBus(for: .campusToStation, from: context.date),
                                now: context.date
                            )
                        } else if let errorMessage = store.errorMessage {
                            ContentUnavailableView(
                                "Timetable Unavailable",
                                systemImage: "exclamationmark.triangle.fill",
                                description: Text(errorMessage)
                            )
                        } else if store.referenceData != nil {
                            ContentUnavailableView(
                                "No Timetable",
                                systemImage: "calendar.badge.exclamationmark",
                                description: Text(store.unavailableMessage(for: context.date))
                            )
                        } else {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 160)
                        }
                    }
                }
                .contentMargins([.horizontal, .bottom], 16, for: .scrollContent)
                .contentMargins(.top, 8, for: .scrollContent)
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("SIT Bus")
        }
    }
}

private struct ClipNextBusCard: View {
    let title: String
    let systemImage: String
    let nextBus: Date?
    let now: Date

    var body: some View {
        GroupBox {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .lastTextBaseline) {
                    nextBusTime
                    Spacer()
                    countdown
                }

                VStack(alignment: .leading, spacing: 4) {
                    nextBusTime
                    countdown
                }
            }
            .monospacedDigit()
            .padding(.top, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label(title, systemImage: systemImage)
        }
        .foregroundStyle(.primary)
    }

    @ViewBuilder
    private var nextBusTime: some View {
        if let nextBus {
            Text(nextBus, format: .dateTime.hour().minute())
                .font(.system(.title, design: .rounded, weight: .semibold))
        } else {
            Text("No more buses")
                .font(.headline)
        }
    }

    @ViewBuilder
    private var countdown: some View {
        if let nextBus {
            let minutes = max(0, Int(ceil(nextBus.timeIntervalSince(now) / 60)))
            if minutes == 0 {
                Text("Departing now")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            } else if minutes >= 60 {
                Text("in \(minutes / 60) hr \(minutes % 60) min")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            } else {
                Text("in \(minutes) min")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct ClipTimetableView: View {
    let store: ClipTimetableStore
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            List {
                DatePicker(
                    "Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )

                if let timetable = store.timetable(for: selectedDate) {
                    Section(timetable.serviceName) {
                        ClipDirectionSection(
                            title: "Station to Campus",
                            times: timetable.times(for: .stationToCampus)
                        )

                        ClipDirectionSection(
                            title: "Campus to Station",
                            times: timetable.times(for: .campusToStation)
                        )
                    }

                    if let comment = store.comment(for: selectedDate), comment.isEmpty == false {
                        Section("Note") {
                            Text(comment)
                        }
                    }
                } else if let errorMessage = store.errorMessage {
                    ContentUnavailableView(
                        "Timetable Unavailable",
                        systemImage: "exclamationmark.triangle.fill",
                        description: Text(errorMessage)
                    )
                } else if store.referenceData != nil {
                    ContentUnavailableView(
                        "No Timetable",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text(store.unavailableMessage(for: selectedDate))
                    )
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Timetable")
        }
    }
}

private struct ClipDirectionSection: View {
    let title: String
    let times: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            if times.isEmpty {
                Text("No bus service")
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 64), spacing: 8)], alignment: .leading, spacing: 8) {
                    ForEach(times, id: \.self) { time in
                        Text(time)
                            .font(.body.monospacedDigit())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

@Observable
private final class ClipTimetableStore {
    private static let remoteURL = URL(string: "http://bus.shibaura-it.ac.jp/db/bus_data.json")!
    private static let decoder = JSONDecoder()

    private(set) var referenceData: ClipReferenceData?
    private(set) var errorMessage: String?

    func load() async {
        guard referenceData == nil else { return }

        loadBundledFallback()
        await refreshRemoteData()
    }

    private func loadBundledFallback() {
        guard let url = Bundle.main.url(forResource: "fallback_bus_data", withExtension: "json") else {
            errorMessage = "Bundled timetable data is missing."
            return
        }

        do {
            let data = try Data(contentsOf: url)
            referenceData = try Self.decoder.decode(ClipReferenceData.self, from: data)
            errorMessage = nil
        } catch {
            errorMessage = "Bundled timetable data could not be read."
        }
    }

    private func refreshRemoteData() async {
        do {
            let (data, response) = try await URLSession.shared.data(from: Self.remoteURL)
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                return
            }

            referenceData = try Self.decoder.decode(ClipReferenceData.self, from: data)
            errorMessage = nil
        } catch {
            if referenceData == nil {
                errorMessage = "Timetable data could not be loaded."
            }
        }
    }

    func timetable(for date: Date) -> ClipTimesheet? {
        guard let referenceData,
              let entry = calendarEntry(for: date),
              !entry.isNoService else { return nil }
        return referenceData.timesheet.first { $0.tsID == entry.tsID }
    }

    func unavailableMessage(for date: Date) -> String {
        if calendarEntry(for: date)?.isNoService == true {
            if let comment = comment(for: date), comment.isEmpty == false {
                return "No bus service is scheduled for this date. \(comment)"
            }
            return "No bus service is scheduled for this date."
        }
        return "The schedule for this date is unavailable."
    }

    func comment(for date: Date) -> String? {
        calendarEntry(for: date)?.comment
    }

    private func calendarEntry(for date: Date) -> ClipCalendarEntry? {
        guard let referenceData else { return nil }

        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: date))
        let month = String(format: "%02d", calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))

        return referenceData.calendar
            .first { $0.year == year && $0.month == month }?
            .list
            .first { $0.day == day }
    }
}

private struct ClipReferenceData: Decodable {
    let timesheet: [ClipTimesheet]
    let calendar: [ClipCalendar]
}

private struct ClipTimesheet: Decodable {
    let title: String
    let tsID: String
    let list: [ClipTimesheetRow]

    var serviceName: String {
        title
            .replacingOccurrences(of: "【", with: "")
            .replacingOccurrences(of: "】", with: " ")
            .replacingOccurrences(of: "大宮キャンパス　スクールバス時刻表", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    enum CodingKeys: String, CodingKey {
        case title
        case tsID = "ts_id"
        case list
    }

    func times(for direction: ClipBusDirection) -> [String] {
        list.flatMap { row in
            row.minutes(for: direction).map { minute in
                "\(row.time):\(minute)"
            }
        }
    }

    func nextBus(for direction: ClipBusDirection, from date: Date = Date()) -> Date? {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        let currentMinute = calendar.component(.minute, from: date)

        return list.lazy.compactMap { row -> Date? in
            guard let hour = Int(row.time), hour >= currentHour else { return nil }

            let nextMinute = row.minutes(for: direction).compactMap(Int.init).first { minute in
                hour > currentHour || minute >= currentMinute
            }

            guard let nextMinute else { return nil }
            return calendar.date(bySettingHour: hour, minute: nextMinute, second: 0, of: date)
        }.first
    }
}

private struct ClipTimesheetRow: Decodable {
    let time: String
    let busLeft: ClipBusTimes
    let busRight: ClipBusTimes

    enum CodingKeys: String, CodingKey {
        case time
        case busLeft = "bus_left"
        case busRight = "bus_right"
    }

    func minutes(for direction: ClipBusDirection) -> [String] {
        let value = switch direction {
        case .stationToCampus:
            busLeft
        case .campusToStation:
            busRight
        }

        return [value.num1, value.num2]
            .flatMap { $0.split(separator: ".") }
            .map(String.init)
            .filter { $0.isEmpty == false }
            .sorted { (Int($0) ?? 0) < (Int($1) ?? 0) }
    }
}

private struct ClipBusTimes: Decodable {
    let num1: String
    let num2: String
}

private struct ClipCalendar: Decodable {
    let year: String
    let month: String
    let list: [ClipCalendarEntry]
}

private struct ClipCalendarEntry: Decodable {
    let day: String
    let tsID: String
    let comment: String

    var isNoService: Bool { tsID.isEmpty || tsID == "none" }

    enum CodingKeys: String, CodingKey {
        case day
        case tsID = "ts_id"
        case comment
    }
}

private enum ClipBusDirection {
    case stationToCampus
    case campusToStation
}

#Preview {
    ContentView()
}
