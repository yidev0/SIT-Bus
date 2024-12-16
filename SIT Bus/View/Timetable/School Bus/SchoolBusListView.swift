//
//  TimetableListView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/23.
//

import SwiftUI

struct SchoolBusListView: View {
    
    @State var scrollPosition: Int?
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
                            } header: {
                                if let hour = formatHour(hour: sheet.hour) {
                                    HStack {
                                        Text(hour, format: .dateTime.hour())
                                            .font(.headline)
                                            .font(.headline)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(.regularMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .scrollPosition(id: $scrollPosition, anchor: .top)
            .contentMargins(16)
            .onAppear {
                self.scrollPosition = Date.now.get(component: .hour)
            }
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
