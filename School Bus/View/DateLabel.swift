//
//  DateLabel.swift
//  School Bus
//
//  Created by Yuto on 2024/08/16.
//

import SwiftUI

struct DateLabel: View {
    
    @Binding var date: Date
    @State var showPopover = false
    
    var body: some View {
        Button {
            showPopover = true
        } label: {
            Text(date, format: .dateTime.month().day().weekday())
        }
        .popover(isPresented: $showPopover) {
            DatePicker(
                selection: $date,
                displayedComponents: .date
            ) {
                Text("Date Picker")
            }
            .datePickerStyle(.graphical)
            .presentationCompactAdaptation(.popover)
        }
    }
}

#Preview {
    @Previewable @State var date = Date.now
    DateLabel(date: $date)
}
