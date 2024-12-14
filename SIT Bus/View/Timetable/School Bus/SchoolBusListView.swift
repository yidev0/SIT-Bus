//
//  TimetableListView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/23.
//

import SwiftUI

struct SchoolBusListView: View {
    
    var timesheet: [TimetableValue]?
    
    var body: some View {
        if let timesheet {
            ScrollView {
                LazyVStack(spacing: 8, pinnedViews: .sectionHeaders) {
                    ForEach(timesheet, id: \.hour) { sheet in
                        if sheet.times.isEmpty == false || sheet.note != nil {
                            Section {
                                VStack(spacing: 8) {
                                    if let date1 = sheet.dateRange1, let date2 = sheet.dateRange2 {
                                        Text("Label.\(Text(date1, format: .dateTime.hour().minute()))to\(Text(date2, format: .dateTime.hour().minute()))Service")
                                            .padding(.vertical, 2)
                                    }
                                    
                                    ForEach(sheet.times, id: \.self) { time in
                                        GroupBox {
                                            HStack {
                                                Text(time, style: .time)
                                                    .monospacedDigit()
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            } header: {
                                if let hour = formatHour(hour: sheet.hour) {
                                    HStack {
                                        Text(hour, format: .dateTime.hour())
                                            .font(.headline)
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 20)
                                    .background(.regularMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 2))
                                }
                            }
                        }
                    }
                }
            }
            .contentMargins(.top, 8)
            .contentMargins(.bottom, 16)
        } else {
            ContentUnavailableView(
                "Label.NoBuses",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }
    
    private func formatHour(hour: Int) -> Date? {
        var components = DateComponents()
        components.hour = hour
        let calendar = Calendar.current
        return calendar.date(from: components)
    }
    
}

#Preview {
    SchoolBusListView()
}
