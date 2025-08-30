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
    }
    
    @ViewBuilder
    func makeCalendarCell(for date: Date) -> some View {
        let isActive = activeDates.contains(date)
        
        VStack(spacing: 2) {
            Button {
                if isActive {
                    self.date = date
                }
            } label: {
                ZStack {
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
                    
                    Text(date.get(.day), format: .number)
                        .font(.body)
                        .fontWeight(calendar.isDate(.now, inSameDayAs: date) ? .bold : .regular)
                        .foregroundStyle(isActive ? .primary : .secondary)
                }
                .aspectRatio(1, contentMode: .fit)
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
            .contentShape(.rect(cornerRadius: 3.5))
            
            if isActive {
                Circle()
                    .frame(height: 6)
                    .foregroundStyle(.tint)
            } else {
                Circle()
                    .frame(height: 6)
                    .hidden()
            }
        }
    }
}

#Preview {
    
    @Previewable @State var date = Date.now
    TimetableCalendarView(date: $date, activeDates: [])
}
