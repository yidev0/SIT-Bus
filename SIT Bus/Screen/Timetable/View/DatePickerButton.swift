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
    
    @State var showPicker = false
    @State var showFullScreenPicker = false
    
    @Binding var selectedDate: Date
    var busCalendar: [BusTimetable.Calendar]?
    
    var activeDatesByMonth: [[Date]]
    var activeMonths: [Date]
    
    init(
        selectedDate: Binding<Date>,
        activeDates: [[Date]]
    ) {
        self._selectedDate = selectedDate
        self.activeDatesByMonth = activeDates
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
            TimetableCalendarView(
                date: $selectedDate,
                activeDates: activeDatesByMonth
            )
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .presentationCompactAdaptation(.popover)
            .presentationBackground(.thickMaterial)
        }
        .fullScreenCover(isPresented: $showFullScreenPicker) {
            TimetableFullDatePickerView(
                date: $selectedDate,
                calendar: busCalendar,
                range: makeRangeForSheet(activeMonths: activeDatesByMonth)
            )
        }
    }
    
    func makeRangeForSheet(activeMonths: [[Date]]) -> ClosedRange<Date> {
        let calendar = Calendar.current
        if activeMonths.isEmpty {
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: .now))!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            return startOfMonth ... endOfMonth
        } else if activeMonths.count == 1 {
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: activeMonths.first!.first!))!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            return startOfMonth ... endOfMonth
        } else {
            return activeMonths.first!.first! ... activeMonths.last!.last!
        }
    }
}

//#Preview {
//    @Previewable @State var date = Date()
//    @Previewable @State var show = false
//    @Previewable @State var full = false
//    
//    VStack {
//        Spacer()
//        
//        DatePickerButton(
//            selectedDate: $date,
//            showPicker: $show, showFullPicker: $full,
//            activeDates: [
//                [
//                    .createDate(year: 2025, month: 2, day: 1)!
//                ],
//                [
//                    .createDate(year: 2025, month: 3, day: 1)!
//                ]
//            ]
//        )
//    }
//    .environment(\.locale, .init(identifier: "ja"))
//}
