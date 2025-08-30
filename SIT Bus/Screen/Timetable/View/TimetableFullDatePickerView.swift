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
    var calendar: [BusTimetable.Calendar]?
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
                    
                    if let calendar = calendar?.first(where: { $0.date == date }),
                       let comment = calendar.comment {
                        Text(calendar.tableName)
                        Text(comment)
                    } else {
                        Text("Label.NoBuses")
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
