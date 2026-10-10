import Foundation
import SwiftUI
import Testing
import UIKit
@testable import SIT_Bus

@Suite @MainActor
struct TimetableCalendarTests {
    private let calendar = BusTimetable.serviceCalendar

    private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 0) throws -> Date {
        try #require(calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour)))
    }

    @Test func serviceDaysNormalizeAcrossTokyoMidnight() throws {
        let beforeMidnight = try date(2026, 10, 10, hour: 23)
        let nextDay = try date(2026, 10, 11)
        let days = TimetableCalendarDays(activeDates: [[], [beforeMidnight, beforeMidnight.addingTimeInterval(-3600)]])
        #expect(days.dates.count == 1)
        #expect(days.contains(beforeMidnight))
        #expect(!days.contains(nextDay))

        let utc = try #require(TimeZone(secondsFromGMT: 0))
        let components = DateComponents(calendar: Calendar(identifier: .buddhist), timeZone: utc, year: 2026, month: 10, day: 10)
        #expect(days.date(from: components) == (try date(2026, 10, 10)))
        #expect(days.date(from: nil) == nil)
    }

    @Test func rangeIncludesWholeMonthsAcrossYearsAndUnsortedBuckets() throws {
        let first = try date(2025, 12, 31, hour: 23)
        let last = try date(2026, 2, 1)
        let days = TimetableCalendarDays(activeDates: [[last], [], [first]])
        let range = try #require(days.availableRange)
        #expect(range.start == (try date(2025, 12, 1)))
        #expect(range.end == (try date(2026, 3, 1)).addingTimeInterval(-1))
        #expect(range.contains(try date(2026, 2, 28, hour: 23)))
        #expect(!range.contains(try date(2026, 3, 1)))
        #expect(!days.contains(try date(2026, 1, 15)))
    }

    @Test func emptyBucketsHaveNoRange() {
        let days = TimetableCalendarDays(activeDates: [[], []])
        #expect(days.availableRange == nil)
        #expect(days.dates.isEmpty)
    }

    private func makeCalendar(parent: NativeTimetableCalendar) -> (UICalendarView, NativeTimetableCalendar.Coordinator) {
        let view = UICalendarView()
        view.calendar = calendar
        view.timeZone = BusTimetable.serviceTimeZone
        let coordinator = NativeTimetableCalendar.Coordinator(parent: parent)
        view.delegate = coordinator
        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: coordinator)
        coordinator.update(view, parent: parent, locale: Locale(identifier: "en_US"))
        return (view, coordinator)
    }

    @Test func selectionRejectsInactiveDaysAndClearing() throws {
        let active = try date(2026, 10, 10)
        var chosen = active
        let days = TimetableCalendarDays(activeDates: [[active]])
        let parent = NativeTimetableCalendar(date: Binding(get: { chosen }, set: { chosen = $0 }), days: days)
        let (view, coordinator) = makeCalendar(parent: parent)
        let selection = try #require(view.selectionBehavior as? UICalendarSelectionSingleDate)
        let inactive = try date(2026, 10, 11)
        #expect(coordinator.dateSelection(selection, canSelectDate: days.components(for: active)))
        #expect(!coordinator.dateSelection(selection, canSelectDate: days.components(for: inactive)))
        #expect(!coordinator.dateSelection(selection, canSelectDate: nil))
        coordinator.dateSelection(selection, didSelectDate: days.components(for: inactive))
        coordinator.dateSelection(selection, didSelectDate: nil)
        #expect(chosen == active)
    }

    @Test func refreshedRangeClearsNativeSelectionWithoutChangingBinding() throws {
        let january = try date(2026, 1, 5)
        let march = try date(2026, 3, 31)
        var chosen = january
        let binding = Binding(get: { chosen }, set: { chosen = $0 })
        let originalDays = TimetableCalendarDays(activeDates: [[january], [march]])
        let (view, coordinator) = makeCalendar(parent: NativeTimetableCalendar(date: binding, days: originalDays))
        let selection = try #require(view.selectionBehavior as? UICalendarSelectionSingleDate)
        #expect(originalDays.date(from: selection.selectedDate) == january)
        let refreshed = TimetableCalendarDays(activeDates: [[march]])
        coordinator.update(view, parent: NativeTimetableCalendar(date: binding, days: refreshed), locale: Locale(identifier: "en_US"))
        #expect(view.availableDateRange == refreshed.availableRange)
        #expect(selection.selectedDate == nil)
        #expect(chosen == january)
        #expect(!coordinator.dateSelection(selection, canSelectDate: originalDays.components(for: january)))
        #expect(coordinator.dateSelection(selection, canSelectDate: refreshed.components(for: march)))
        #expect(view.visibleDateComponents.year == 2026)
        #expect(view.visibleDateComponents.month == 3)
    }

    @Test func updatesPreserveBrowsingAndUseCurrentBinding() throws {
        let january = try date(2026, 1, 5)
        let december = try date(2026, 12, 31)
        var oldChosen = january
        var newChosen = january
        let days = TimetableCalendarDays(activeDates: [[january], [december]])
        let (view, coordinator) = makeCalendar(parent: NativeTimetableCalendar(
            date: Binding(get: { oldChosen }, set: { oldChosen = $0 }), days: days
        ))
        let browsed = try date(2026, 6, 1)
        view.setVisibleDateComponents(days.components(for: browsed), animated: false)
        let newParent = NativeTimetableCalendar(date: Binding(get: { newChosen }, set: { newChosen = $0 }), days: days)
        coordinator.update(view, parent: newParent, locale: Locale(identifier: "en_US"))
        #expect(view.visibleDateComponents.year == 2026)
        #expect(view.visibleDateComponents.month == 6)
        let selection = try #require(view.selectionBehavior as? UICalendarSelectionSingleDate)
        coordinator.dateSelection(selection, didSelectDate: days.components(for: december))
        #expect(newChosen == december)
        #expect(oldChosen == january)
        coordinator.update(view, parent: newParent, locale: Locale(identifier: "en_US"))
        #expect(days.date(from: selection.selectedDate) == december)
    }

    @Test func timetableTypesUseDistinctPairsAndMatchDuplicateServiceDays() throws {
        let firstDay = try date(2026, 10, 10)
        let secondDay = try date(2026, 10, 11)
        let entries: [BusTimetable.Calendar] = [
            .init(date: firstDay, tableName: "Weekday"),
            .init(date: firstDay.addingTimeInterval(3600), tableName: "Ignored duplicate"),
            .init(date: secondDay, tableName: "Saturday")
        ]
        let indicators = TimetableCalendarIndicators(entries: entries)
        #expect(indicators.types.map(\.name) == ["Saturday", "Weekday"])
        #expect(indicators.marker(for: firstDay.addingTimeInterval(7200)) == indicators.types[1].marker)
        #expect(indicators.marker(for: secondDay) == indicators.types[0].marker)
        #expect(indicators.marker(for: try date(2026, 10, 12)) == nil)
        let reordered = TimetableCalendarIndicators(entries: [entries[2], entries[0], entries[1]])
        #expect(reordered == indicators)

        let symbols = (0..<12).map { TimetableCalendarMarker(index: $0).symbol }
        #expect(Set(symbols).count == 12)
        for symbol in symbols {
            #expect(UIImage(systemName: symbol) != nil)
        }
    }

    @Test func optionalMarkersRefreshWithoutResettingBrowsingOrSelection() throws {
        let january = try date(2026, 1, 5)
        let december = try date(2026, 12, 31)
        var chosen = january
        let binding = Binding(get: { chosen }, set: { chosen = $0 })
        let days = TimetableCalendarDays(activeDates: [[january, december]])
        let indicators = TimetableCalendarIndicators(entries: [.init(date: january, tableName: "Weekday")])
        var parent = NativeTimetableCalendar(date: binding, days: days, indicators: indicators)
        let (view, coordinator) = makeCalendar(parent: parent)
        let components = days.components(for: january)
        #expect(!parent.showsTimetableTypes)
        #expect(!view.wantsDateDecorations)
        #expect(coordinator.calendarView(view, decorationFor: components) == nil)
        view.setVisibleDateComponents(days.components(for: try date(2026, 6, 1)), animated: false)

        parent.showsTimetableTypes = true
        coordinator.update(view, parent: parent, locale: Locale(identifier: "en_US"))
        #expect(view.wantsDateDecorations)
        #expect(coordinator.calendarView(view, decorationFor: components) != nil)
        #expect(coordinator.calendarView(view, decorationFor: days.components(for: try date(2026, 1, 6))) == nil)
        #expect(view.visibleDateComponents.month == 6)
        #expect(chosen == january)

        parent.indicators = TimetableCalendarIndicators(entries: [.init(date: december, tableName: "Holiday")])
        coordinator.update(view, parent: parent, locale: Locale(identifier: "en_US"))
        #expect(coordinator.calendarView(view, decorationFor: components) == nil)
        #expect(coordinator.calendarView(view, decorationFor: days.components(for: december)) != nil)
        #expect(view.visibleDateComponents.month == 6)

        parent.indicators = TimetableCalendarIndicators(entries: [
            .init(date: december, tableName: "Saturday"), .init(date: january, tableName: "Holiday")
        ])
        coordinator.update(view, parent: parent, locale: Locale(identifier: "en_US"))
        #expect(coordinator.parent.indicators.marker(for: december) == parent.indicators.types[1].marker)
        parent.showsTimetableTypes = false
        coordinator.update(view, parent: parent, locale: Locale(identifier: "en_US"))
        #expect(!view.wantsDateDecorations)
        #expect(coordinator.calendarView(view, decorationFor: days.components(for: december)) == nil)
        #expect(view.visibleDateComponents.month == 6)
        #expect(chosen == january)
    }

    @Test func symbolsFollowServiceDayFrequencyWithStableNameTies() throws {
        let entries: [BusTimetable.Calendar] = [
            .init(date: try date(2026, 1, 1), tableName: "Z Weekday"),
            .init(date: try date(2026, 1, 2), tableName: "Z Weekday"),
            .init(date: try date(2026, 2, 3), tableName: "Z Weekday"),
            .init(date: try date(2026, 2, 4), tableName: "A Saturday"),
            .init(date: try date(2026, 2, 5), tableName: "A Saturday"),
            .init(date: try date(2026, 2, 6), tableName: "A Holiday"),
            .init(date: try date(2026, 2, 7), tableName: "B Holiday")
        ]
        // Duplicate rows must not inflate the frequency of another type.
        let duplicates = (0..<10).map { _ in
            BusTimetable.Calendar(date: entries[0].date.addingTimeInterval(3600), tableName: "B Holiday")
        }
        let indicators = TimetableCalendarIndicators(entries: entries + duplicates)
        #expect(indicators.types.map(\.name) == ["Z Weekday", "A Saturday", "A Holiday", "B Holiday"])
        #expect(indicators.types.map { $0.marker.symbol } == ["circle.fill", "square.fill", "triangle.fill", "rhombus.fill"])
        #expect(indicators.marker(for: entries[0].date) == indicators.types[0].marker)
        #expect(indicators.marker(for: entries[3].date) == indicators.types[1].marker)
        #expect(TimetableCalendarIndicators(entries: Array(entries.reversed()) + duplicates) == indicators)
    }

}
