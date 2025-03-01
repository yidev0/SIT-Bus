//
//  TimetableFullDatePickerView.swift
//  SIT Bus
//
//  Created by Yuto on 2025/03/01.
//

import SwiftUI

struct TimetableFullDatePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var date: Date
    var data: SBReferenceData?
    var range: ClosedRange<Date>
    
    var body: some View {
        NavigationStack {
            HStack {
                List {
                    DatePicker(
                        "Label.Calendar",
                        selection: $date,
                        in: range,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .listRowInsets(.init())
                }
                
                List {
                    Text(date, format: .dateTime.year().month().day().weekday())
                    
                    if let title = data?.getCalendarName(for: date) {
                        Text(title)
                    } else {
                        Text("Label.NoBuses")
                    }
                    
                    if let comment = data?.getComment(for: date) {
                        Text(comment)
                    }
                }
            }
            .toolbar {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Text("Button.Done")
                }
            }
            .toolbarTitleDisplayMode(.inline)
        }
    }
}
