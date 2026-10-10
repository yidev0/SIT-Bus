//
//  TimetableCalendarView.swift
//  SIT Bus
//
//  Created by Yuto on 2025/08/31.
//

import SwiftUI
import UIKit

struct TimetableCalendarView: View {
    @Binding var date: Date
    var activeDates: [[Date]]
    var indicators = TimetableCalendarIndicators(entries: [])
    var showsTimetableTypes = false

    var body: some View {
        let days = TimetableCalendarDays(activeDates: activeDates)
        if days.availableRange != nil {
            NativeTimetableCalendar(date: $date, days: days, indicators: indicators, showsTimetableTypes: showsTimetableTypes)
                .frame(maxWidth: .infinity)
        } else {
            ContentUnavailableView(.noBuses, systemImage: "calendar")
        }
    }
}

/// Service days use the timetable's calendar, independently of the device time zone.
struct TimetableCalendarDays: Equatable {
    let dates: Set<Date>
    let availableRange: DateInterval?

    init(activeDates: [[Date]]) {
        let calendar = BusTimetable.serviceCalendar
        dates = Set(activeDates.joined().map { calendar.startOfDay(for: $0) })
        if let first = dates.min(), let last = dates.max(),
           let firstMonth = calendar.dateInterval(of: .month, for: first),
           let lastMonth = calendar.dateInterval(of: .month, for: last) {
            // Include all of the final day, without exposing the next month.
            availableRange = DateInterval(start: firstMonth.start, end: lastMonth.end.addingTimeInterval(-1))
        } else {
            availableRange = nil
        }
    }

    func contains(_ date: Date) -> Bool {
        dates.contains(BusTimetable.serviceCalendar.startOfDay(for: date))
    }

    func components(for date: Date) -> DateComponents {
        BusTimetable.serviceCalendar.dateComponents([.year, .month, .day], from: date)
    }

    func date(from components: DateComponents?) -> Date? {
        guard let components, let year = components.year,
              let month = components.month, let day = components.day else { return nil }
        // Ignore any calendar/time zone carried by the delegate's components.
        return BusTimetable.serviceCalendar.date(from: DateComponents(year: year, month: month, day: day))
    }

    func clamped(_ date: Date) -> Date {
        guard let availableRange else { return date }
        return min(max(date, availableRange.start), availableRange.end)
    }
}

/// A single descriptor supplies both the native decoration and its legend.
struct TimetableCalendarMarker: Hashable {
    let index: Int
    private static let symbols = [
        "circle",
        "square",
        "triangle",
        "rhombus",
        "seal",
        "oval"
    ]
    private static let colors: [UIColor] = [
        .systemBlue,
        .systemOrange,
        .systemPurple,
        .systemTeal,
        .systemPink,
        .systemBrown
    ]

    var color: UIColor {
        Self.colors[index % Self.colors.count]
    }

    var symbol: String {
        let symbolCount = Self.symbols.count
        let fill = (index / symbolCount) % 2 == 0
        return Self.symbols[index % symbolCount] + (fill ? ".fill" : "")
    }
}

struct TimetableCalendarIndicators: Equatable {
    struct TimetableType: Equatable, Identifiable {
        let name: String
        let marker: TimetableCalendarMarker
        var id: String { name }
    }

    let types: [TimetableType]
    let markersByDay: [Date: TimetableCalendarMarker]

    init(entries: [BusTimetable.Calendar]) {
        // Rank by service-day frequency across the full calendar, keeping the
        // most common timetable first even while browsing another month.
        // Duplicate service dates match BusTimetable's first entry.
        let entriesByDay = Dictionary(entries.map {
            (BusTimetable.serviceCalendar.startOfDay(for: $0.date), $0.tableName)
        }, uniquingKeysWith: { first, _ in first })
        var counts: [String: Int] = [:]
        for name in entriesByDay.values {
            counts[name, default: 0] += 1
        }
        let names = counts.keys.sorted { lhs, rhs in
            let leftCount = counts[lhs, default: 0]
            let rightCount = counts[rhs, default: 0]
            return leftCount == rightCount ? lhs < rhs : leftCount > rightCount
        }
        types = names.enumerated().map {
            TimetableType(name: $0.element, marker: TimetableCalendarMarker(index: $0.offset))
        }
        let markersByName = Dictionary(uniqueKeysWithValues: types.map { ($0.name, $0.marker) })
        markersByDay = entriesByDay.compactMapValues { markersByName[$0] }
    }

    func marker(for date: Date) -> TimetableCalendarMarker? {
        markersByDay[BusTimetable.serviceCalendar.startOfDay(for: date)]
    }
}

enum TimetableCalendarName {
    static func displayName(for name: String) -> String {
        for suffix in ["スクールバス時刻表", "学バス時刻表"] where name.hasSuffix(suffix) {
            return String(name.dropLast(suffix.count)).trimmingCharacters(in: .whitespaces)
        }
        return name
    }
}

struct TimetableCalendarLegend: View {
    let types: [TimetableCalendarIndicators.TimetableType]

    var body: some View {
        ForEach(types) { type in
            Label {
                Text(verbatim: TimetableCalendarName.displayName(for: type.name))
                    .foregroundStyle(Color.primary)
            } icon: {
                Image(systemName: type.marker.symbol)
                    .foregroundStyle(Color(type.marker.color))
            }
            .font(.subheadline)
        }
    }
}

struct NativeTimetableCalendar: UIViewRepresentable {
    @Environment(\.locale) private var locale
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var visibleMonth: DateComponents?
    @Binding var date: Date
    let days: TimetableCalendarDays
    var indicators = TimetableCalendarIndicators(entries: [])
    var showsTimetableTypes = false

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = BusTimetable.serviceCalendar
        view.timeZone = BusTimetable.serviceTimeZone
        view.locale = locale
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.wantsDateDecorations = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.delegate = context.coordinator
        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        context.coordinator.update(view, parent: self, locale: locale)
        return view
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Month and text-size changes also request a fresh fitting measurement.
        let _ = (visibleMonth, dynamicTypeSize)
        context.coordinator.update(uiView, parent: self, locale: locale)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UICalendarView, context: Context) -> CGSize? {
        guard let proposedWidth = proposal.width, proposedWidth.isFinite, proposedWidth > 0 else { return nil }
        // UIKit caps the month grid at its natural width. Match that width so
        // offscreen neighboring months cannot draw in unused side margins.
        let naturalSize = uiView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let width = naturalSize.width > 0 ? min(proposedWidth, naturalSize.width) : proposedWidth
        let size = uiView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return CGSize(width: width, height: size.height)
    }

    static func dismantleUIView(_ uiView: UICalendarView, coordinator: Coordinator) {
        uiView.delegate = nil
        uiView.selectionBehavior = nil
    }

    @MainActor
    final class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: NativeTimetableCalendar
        private var displayedDays: TimetableCalendarDays?
        private var displayedIndicators: TimetableCalendarIndicators?
        private var displayedShowsTimetableTypes = false
        private var selectedDay: Date?
        private var isUpdating = false

        init(parent: NativeTimetableCalendar) {
            self.parent = parent
        }

        func update(_ view: UICalendarView, parent: NativeTimetableCalendar, locale: Locale) {
            self.parent = parent
            guard let range = parent.days.availableRange,
                  let selection = view.selectionBehavior as? UICalendarSelectionSingleDate else { return }
            isUpdating = true
            defer { isUpdating = false }
            if view.locale != locale {
                view.locale = locale
            }

            let day = BusTimetable.serviceCalendar.startOfDay(for: parent.date)
            let rangeChanged = displayedDays?.availableRange != range
            let dateChanged = selectedDay != day
            if rangeChanged {
                selection.setSelected(nil, animated: false)
                // UIKit requires the visible date to be in range. Expand before
                // moving it, then narrow; this also handles historical initial data.
                let oldRange = view.availableDateRange
                view.availableDateRange = DateInterval(
                    start: min(oldRange.start, range.start),
                    end: max(oldRange.end, range.end)
                )
            }
            if rangeChanged || dateChanged {
                var visibleComponents = view.visibleDateComponents
                visibleComponents.day = visibleComponents.day ?? 1
                let browsedDate = parent.days.date(from: visibleComponents) ?? parent.date
                let visibleDate = parent.days.clamped(dateChanged ? day : browsedDate)
                view.setVisibleDateComponents(parent.days.components(for: visibleDate), animated: false)
            }
            if rangeChanged {
                view.availableDateRange = range
            }
            if displayedDays != parent.days {
                selection.updateSelectableDates()
            }
            let desiredDay = parent.days.contains(day) ? day : nil
            // UIKit adds calendar/era fields to selectedDate. Compare service days
            // so unrelated updates don't select again and reset the browsed month.
            if parent.days.date(from: selection.selectedDate) != desiredDay {
                selection.setSelected(desiredDay.map(parent.days.components(for:)), animated: false)
            }
            if displayedIndicators != parent.indicators || displayedShowsTimetableTypes != parent.showsTimetableTypes {
                let affectedDays = Set(displayedIndicators?.markersByDay.keys.map { $0 } ?? [])
                    .union(parent.indicators.markersByDay.keys)
                view.wantsDateDecorations = parent.showsTimetableTypes
                view.reloadDecorations(forDateComponents: affectedDays.map(parent.days.components(for:)), animated: false)
                displayedIndicators = parent.indicators
                displayedShowsTimetableTypes = parent.showsTimetableTypes
            }
            displayedDays = parent.days
            selectedDay = day
            view.invalidateIntrinsicContentSize()
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate components: DateComponents?) -> Bool {
            guard let date = parent.days.date(from: components) else { return false }
            return parent.days.contains(date)
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate components: DateComponents?) {
            guard !isUpdating, let date = parent.days.date(from: components),
                  parent.days.contains(date) else { return }
            parent.date = date
        }

        func calendarView(_ calendarView: UICalendarView, decorationFor components: DateComponents) -> UICalendarView.Decoration? {
            guard parent.showsTimetableTypes, let date = parent.days.date(from: components),
                  parent.days.contains(date), let marker = parent.indicators.marker(for: date) else { return nil }
            return .image(
                .init(systemName: marker.symbol),
                color: marker.color,
                size: .small
            )
        }

        func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
            guard !isUpdating else { return }
            parent.visibleMonth = calendarView.visibleDateComponents
            calendarView.invalidateIntrinsicContentSize()
        }
    }
}

#Preview {
    @Previewable @State var date = Date.now
    ScrollView {
        TimetableCalendarView(
            date: $date,
            activeDates: [[1, 10, 20, 30].map { Date.now.startOfDay(after: $0) }]
        )
        .padding()
    }
}
