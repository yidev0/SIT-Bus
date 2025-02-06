//
//  DatePickerButton.swift
//  School Bus
//
//  Created by Yuto on 2024/08/18.
//

import SwiftUI

struct DatePickerButton: View {
    
    @Environment(\.calendar) var calendar
    
    @Binding var selectedDate: Date
    @Binding var showPicker: Bool
    
    @State var tabSelection: [Date]
    var activeDates: [[Date]]
    
    init(
        selectedDate: Binding<Date>,
        showPicker: Binding<Bool>,
        activeDates: [[Date]]
    ) {
        self._selectedDate = selectedDate
        self._showPicker = showPicker
        
        self.activeDates = activeDates
        
        let selectedMonthTab = activeDates.first(where: {
            $0.contains(where: {
                Calendar.current.isDate($0, inSameDayAs: selectedDate.wrappedValue)
            })
        })
        self._tabSelection = .init(initialValue: selectedMonthTab ?? [])
    }
    
    var body: some View {
        Button {
            showPicker = true
        } label: {
            Text(selectedDate, format: .dateTime.day().month().weekday())
        }
        .popover(isPresented: $showPicker, arrowEdge: .bottom) {
            tabView
        }
    }
    
    var tabView: some View {
        TabView(selection: $tabSelection) {
            ForEach(activeDates, id: \.self) { dates in
                CalendarView(month: dates.first ?? .now) { date in
                    Button {
                        selectedDate = date
                    } label: {
                        ZStack {
                            if calendar.isDate(date, inSameDayAs: selectedDate) {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(.tint)
                            } else if calendar.isDateInToday(date) {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(Color.secondary)
                            } else {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(.clear)
                            }
                            
                            Text(String(date.get(component: .day)))
                                .font(.system(size: 17))
                                .foregroundStyle(Color.primary)
                        }
                        .aspectRatio(1, contentMode: .fill)
                        .overlay {
                            if isActive(date, set: dates) {
                                RoundedRectangle(cornerRadius: 3.5)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(.tint)
                                    .padding(2)
                            }
                        }
                    }
                    .accessibilityLabel(Text(date, format: .dateTime.weekday(.wide).month().day()))
                    .accessibilityValue(
                        Text("Label.Accessibility.NoBusService"),
                        isEnabled: !isActive(date, set: dates)
                    )
                    .accessibilityValue(
                        Text("Label.Accessibility.Today"),
                        isEnabled: calendar.isDateInToday(date)
                    )
                    .addAccessiblityTraits(for: calendar.isDate(date, inSameDayAs: selectedDate))
                    .contentShape(.rect(cornerRadius: 3.5))
                } label: {
                    HStack {
                        Text((dates.first ?? .now).getMonthText())
                            .font(.headline)
                        Spacer()
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .presentationCompactAdaptation(.popover)
        .presentationBackground(.regularMaterial)
        .frame(minWidth: 312, minHeight: 288)
    }
    
    func isActive(_ input: Date, set: [Date]) -> Bool {
        set.contains { date in
            calendar.isDate(date, inSameDayAs: input)
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    @Previewable @State var show = false
    
    DatePickerButton(
        selectedDate: $date,
        showPicker: $show,
        activeDates: [
            [
                .now,
                .init(timeIntervalSinceNow: -259200),
                .init(timeIntervalSinceNow: 86400),
                .init(timeIntervalSinceNow: 259200),
                .distantFuture
            ]
        ]
    )
    .environment(\.locale, .init(identifier: "ja"))
}
