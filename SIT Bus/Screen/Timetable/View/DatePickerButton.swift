//
//  DatePickerButton.swift
//  School Bus
//
//  Created by Yuto on 2024/08/18.
//

import SwiftUI

struct DatePickerButton: View {
    
    @Environment(\.calendar) var calendar
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ScaledMetric(wrappedValue: 70, relativeTo: .largeTitle)
    var header
    
    @Binding var selectedDate: Date
    @Binding var showPicker: Bool
    @Binding var showFullScreenPicker: Bool
    
    var activeDates: [Date]
    var activeMonths: [Date]
    
    init(
        selectedDate: Binding<Date>,
        showPicker: Binding<Bool>,
        showFullPicker: Binding<Bool>,
        activeDates: [[Date]]
    ) {
        self._selectedDate = selectedDate
        self._showPicker = showPicker
        self._showFullScreenPicker = showFullPicker
        
        self.activeDates = activeDates.flatMap { $0 }
        
        self.activeMonths = activeDates.compactMap { $0.first }
    }
    
    var body: some View {
        Button {
            if UIDevice.current.userInterfaceIdiom == .phone && ( UIDevice.current.orientation.isLandscape || horizontalSizeClass == .regular) {
                showFullScreenPicker = true
            } else {
                showPicker = true
            }
        } label: {
            Text(selectedDate, format: .dateTime.day().month().weekday())
        }
        .popover(isPresented: $showPicker, arrowEdge: .bottom) {
            CalendarView(
                selectedDate: $selectedDate,
                activeMonths: activeMonths
            ) { date in
                makeCalendarCell(for: date)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .frame(
                width: 320,
                height: CGFloat(header) + (activeMonths.map { CGFloat($0.calendarRows()) }.max() ?? 5) * 54
            )
            .presentationCompactAdaptation(.popover)
            .presentationBackground(.thickMaterial)
        }
    }
    
    @ViewBuilder
    func makeCalendarCell(for date: Date) -> some View {
        let isActive = activeDates.contains(date)
        
        VStack(spacing: 2) {
            Button {
                if isActive {
                    selectedDate = date
                }
            } label: {
                ZStack {
                    if Calendar.current.isDate(selectedDate, inSameDayAs: date) {
                        Circle()
                            .foregroundStyle(.tint.secondary)
                    } else if Calendar.current.isDate(.now, inSameDayAs: date) {
                        Circle()
                            .foregroundStyle(.tertiary)
                    } else {
                        Circle()
                            .hidden()
                    }
                    
                    Text(date.get(component: .day), format: .number)
                        .font(.body)
                        .fontWeight(Calendar.current.isDate(.now, inSameDayAs: date) ? .bold : .regular)
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
            .addAccessiblityTraits(for: calendar.isDate(date, inSameDayAs: selectedDate))
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
    @Previewable @State var date = Date()
    @Previewable @State var show = false
    @Previewable @State var full = false
    
    VStack {
        Spacer()
        
        DatePickerButton(
            selectedDate: $date,
            showPicker: $show, showFullPicker: $full,
            activeDates: [
                [
                    .createDate(year: 2025, month: 2, day: 1)!
                ],
                [
                    .createDate(year: 2025, month: 3, day: 1)!
                ]
            ]
        )
    }
    .environment(\.locale, .init(identifier: "ja"))
}
