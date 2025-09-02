//
//  TimetableCompactMenu.swift
//  SIT Bus
//
//  Created by Yuto on 2025/09/02.
//

import SwiftUI

struct TimetableCompactMenu: View {
    
    @Environment(TimetableViewModel.self)
    var model
    
    @Environment(\.dynamicTypeSize)
    var dynamicTypeSize
    
    var namespace: Namespace.ID
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) {
                datePicker
                busPicker
            }
            
            VStack(spacing: 8) {
                datePicker
                busPicker
            }
        }
        .padding(.bottom, 12)
    }
    
    @ViewBuilder
    var datePicker: some View {
        @Bindable var model = model
        
        if #available(iOS 26, *) {
            Button {
                model.showDatePicker = true
            } label: {
                Text(model.date, format: dynamicTypeSize > .xxxLarge ? .dateTime.day().month() :  .dateTime.day().month().weekday())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .matchedTransitionSource(id: "DatePicker", in: namespace)
            }
            .buttonBorderShape(.capsule)
            .contentShape(.capsule)
            .buttonStyle(.glass)
            
        } else {
            DatePickerButton(
                selectedDate: $model.date,
                activeDates: model.timetable?.getActiveDates() ?? []
            )
            .buttonStyle(.filter)
        }
    }
    
    @ViewBuilder
    var busPicker: some View {
        @Bindable var model = model
        
        if #available(iOS 26.0, *) {
            BusPickerView(
                selectedBus: $model.timesheetBus,
                glassPadding: true
            )
            .buttonStyle(.glass)
        } else {
            BusPickerView(
                selectedBus: $model.timesheetBus
            )
            .buttonStyle(.filter)
        }
    }
}

#Preview {
    @Previewable @State var model = TimetableViewModel()
    @Previewable @Namespace var namespace
    
    TimetableCompactMenu(namespace: namespace)
        .environment(model)
}
