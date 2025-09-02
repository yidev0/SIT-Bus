//
//  TimetableCalendarView.swift
//  SIT Bus
//
//  Created by Yuto on 2025/08/31.
//

import SwiftUI

struct TimetableCalendarView: View {
    
    @Environment(\.calendar)
    var calendar
    
    @Binding
    var date: Date
    
    @ScaledMetric(relativeTo: .largeTitle)
    var header = 50
    
    @ScaledMetric(relativeTo: .caption2)
    var circleSize: CGFloat = 17
    
    @Environment(\.dynamicTypeSize)
    var dynamicTypeSize
    
    var activeDates: [Date]
    var activeMonths: [Date]
    
    init(date: Binding<Date>, activeDates: [[Date]]) {
        self._date = date
        self.activeDates = activeDates.flatMap { $0 }
        self.activeMonths = activeDates.compactMap { $0.first }
    }
    
    var body: some View {
        CalendarView(
            selectedDate: $date,
            activeMonths: activeMonths
        ) { date in
            makeCalendarCell(for: date)
        }
        .frame(
            minWidth: 328,
            minHeight: CGFloat(header) + ((activeMonths.map { CGFloat($0.calendarRows()) }.max() ?? 5) + 1) * (min(circleSize, 34) + 4 + 8 + 8) + 16
        )
    }
    
    @ViewBuilder
    private func makeCalendarCell(for date: Date) -> some View {
        let isActive = activeDates.contains(date)
        
        Button {
            if isActive {
                self.date = date
            }
        } label: {
            VStack(spacing: 4) {
                Text(date.get(.day), format: .number)
                    .font(.body)
                    .fontWeight(textWeight(date: date))
                    .foregroundStyle(isActive ? .primary : .secondary)
                    .frame(
                        width: min(circleSize, 34) + 10,
                        height: min(circleSize, 34) + 10
                    )
                    .background {
                        if calendar.isDate(self.date, inSameDayAs: date) {
                            Circle()
                                .foregroundStyle(.tint.secondary)
                        } else if calendar.isDate(.now, inSameDayAs: date) {
                            Circle()
                                .foregroundStyle(.tertiary)
                        } else {
                            Circle()
                                .hidden()
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                
                if isActive {
                    Circle()
                        .frame(height: 8)
                        .foregroundStyle(.tint)
                } else {
                    Circle()
                        .frame(height: 8)
                        .hidden()
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(date, format: .dateTime.weekday(.wide).month().day()))
        .accessibilityValue(
            Text("Label.Accessibility.NoBusService"),
            isEnabled: !isActive
        )
        .accessibilityValue(
            Text("Label.Accessibility.Today"),
            isEnabled: calendar.isDateInToday(date)
        )
        .addAccessiblityTraits(for: calendar.isDate(date, inSameDayAs: self.date))
    }
    
    private func textWeight(date: Date) -> Font.Weight {
        let isSameDay = calendar.isDate(.now, inSameDayAs: date)
        return switch (dynamicTypeSize) {
        case .accessibility1...DynamicTypeSize.accessibility5:
            isSameDay ? .bold : .regular
        default:
            isSameDay ? .semibold : .regular
        }
    }
    
}

#Preview {
    @Previewable @Environment(\.calendar) var calendar
    @Previewable @State var date = Date.now
    
    TimetableCalendarView(
        date: $date,
        activeDates: [
            [1,10,20,30].map({ Date.now.startOfDay(after: $0) }),
            [35,36].map({ Date.now.startOfDay(after: $0) }),
        ]
    )
}
