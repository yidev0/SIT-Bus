//
//  CalendarView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/16.
//
// ref: https://swiftwithmajid.com/2020/05/06/building-calendar-without-uicollectionview-in-swiftui/

import SwiftUI

struct CalendarView<DateView: View, MonthView: View>: View {
    
    @Environment(\.dynamicTypeSize)
    var dynamicTypeSize
    
    @Environment(\.calendar) var calendar
    let month: Date
    
    @ViewBuilder
    let content: (Date) -> DateView
    @ViewBuilder
    let label: MonthView
    
    private var dates: [Date] {
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
    
    var body: some View {
        VStack {
            label
            
            LazyVGrid(
                columns: .init(
                    repeating: .init(
                        .flexible(minimum: 20, maximum: 60),
                        spacing: 4
                    ),
                    count: 7
                ),
                spacing: 4
            ) {
                ForEach(0..<7) { index in
                    Text((dynamicTypeSize.isAccessibilitySize ? calendar.veryShortStandaloneWeekdaySymbols: calendar.shortWeekdaySymbols)[index])
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
                
                ForEach(dates, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        content(date)
                    } else {
                        content(date)
                            .hidden()
                    }
                }
            }
        }
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
    CalendarView(month: .now) { date in
        Text(date, format: .dateTime.day())
    } label: {
        Text(Date.now.getMonthText())
    }
}
