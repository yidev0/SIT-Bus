//
//  SettingsSourcesView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/22.
//

import SwiftUI

struct SettingsSourcesView: View {
    
    var lastUpdatedDate: Date
    
    var body: some View {
        List {
            Section {
                Text("Detail.BusInfo")
            }
            
            Section("Label.AutoUpdateSource") {
                LinkButton("http://bus.shibaura-it.ac.jp/developer.html") {
                    SettingsSourceLabel(
                        label: "Label.SchoolBus",
                        date: lastUpdatedDate,
                        format: .dateTime.year().month().day().hour().minute()
                    )
                }
            }
            
            Section {
                LinkButton("https://www.shibaura-it.ac.jp/access/index.html#bus") {
                    SettingsSourceLabel(
                        label: "Label.ShuttleBus",
                        date: Date.createDate(year: 2024, month: 9, day: 23)!,
                        format: .dateTime.year().month().day()
                    )
                }
                
                LinkButton("https://www.shibaura-it.ac.jp/assets/jikoku_iwatsuki.pdf") {
                    SettingsSourceLabel(
                        label: "Label.SchoolBusIwatsuki",
                        date: .createDate(year: 2024, month: 9, day: 30)!,
                        format: .dateTime.year().month().day()
                    )
                }
            }
        }
    }
}

#Preview {
    SettingsSourcesView(lastUpdatedDate: .now)
}
