//
//  CalendarView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/16.
//
// ref: https://swiftwithmajid.com/2020/05/06/building-calendar-without-uicollectionview-in-swiftui/

import SwiftUI

struct CalendarView<DateView: View>: View {
    
    @Environment(\.dynamicTypeSize)
    var dynamicTypeSize
    
    @Environment(\.calendar)
    var calendar
    
    @ViewBuilder
    let content: (Date) -> DateView
    
    @State
    var selectedMonth: Int
    
    @Binding
    var selectedDate: Date
    var activeMonths: [Date]
    
    init(
        selectedDate: Binding<Date>,
        activeMonths: [Date],
        content: @escaping (Date) -> DateView
    ) {
        self._selectedDate = selectedDate
        self.activeMonths = activeMonths
        
        self.content = content
        
        self.selectedMonth = selectedDate.wrappedValue.get(.month)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(calendar.standaloneMonthSymbols[selectedMonth - 1])
                .font(.headline)
                .padding(.horizontal, 8)
            
            LazyVGrid(
                columns: .init(
                    repeating: .init(
                        .flexible(minimum: 20, maximum: 60),
                        spacing: 8
                    ),
                    count: 7
                )
            ) {
                ForEach(0..<7) { index in
                    Text(calendar.veryShortStandaloneWeekdaySymbols[index])
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
            }
            
            TabView(selection: $selectedMonth) {
                ForEach(activeMonths, id: \.self) { month in
                    Tab(value: month.get(.month)) {
                        VStack {
                            LazyVGrid(
                                columns: .init(
                                    repeating: .init(
                                        .flexible(minimum: 20, maximum: 60),
                                        spacing: 8
                                    ),
                                    count: 7
                                ),
                                spacing: 8
                            ) {
                                ForEach(makeDates(for: month), id: \.self) { date in
                                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                        content(date)
                                    } else {
                                        content(date)
                                            .hidden()
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
    
    private func makeDates(for month: Date) -> [Date] {
        var returnValue: [Date] = []
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        let weeks = calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
        
        for week in weeks {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
            let dates = calendar.generateDates(
                inside: weekInterval,
                matching: DateComponents(hour: 0, minute: 0, second: 0)
            )
            returnValue.append(contentsOf: dates)
        }
        
        return returnValue
    }
    
    
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

#Preview {
    @Previewable @State var selected = Date.now
    let activeMonths: [Date] = [
        .now,
        .now.addingTimeInterval(2592000),
        .now.addingTimeInterval(3592000),
    ]
    
    CalendarView(
        selectedDate: $selected,
        activeMonths: activeMonths
    ) { date in
        VStack(spacing: 2) {
            Button {
                selected = date
            } label: {
                ZStack {
                    if Calendar.current.isDate(selected, inSameDayAs: date) {
                        Circle()
                            .foregroundStyle(.tint.secondary)
                    } else {
                        Circle()
                            .hidden()
                    }
                    
                    Text(date, format: .dateTime.day())
                        .font(.body)
                        .fontWeight(Calendar.current.isDate(.now, inSameDayAs: date) ? .bold : .regular)
                }
                .aspectRatio(1, contentMode: .fit)
            }
            .buttonStyle(.plain)
            
            Circle()
                .frame(height: 6)
        }
    }
    .frame(
        width: 320,
        height: 70 + (activeMonths.map { CGFloat($0.calendarRows()) }.max() ?? 5) * 52
    )
    .background(.thinMaterial)
    
}
