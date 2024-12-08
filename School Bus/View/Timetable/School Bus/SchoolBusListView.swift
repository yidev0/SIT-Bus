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
                VStack(spacing: 8) {
                    ForEach(timesheet, id: \.hour) { sheet in
                        if sheet.times.isEmpty == false {
                            Section {
                                if let note = sheet.note {
                                    Text(note)
                                }
                                
                                ForEach(sheet.times, id: \.self) { minute in
                                    GroupBox {
                                        HStack {
                                            Text("\(sheet.hour):\(minute)")
                                            Spacer()
                                        }
                                    }
                                }
                            } header: {
                                HStack {
                                    Text("\(sheet.hour)")
                                        .font(.headline)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        } else {
            ContentUnavailableView(
                "Label.NoBuses",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }
}

#Preview {
    SchoolBusListView()
}
