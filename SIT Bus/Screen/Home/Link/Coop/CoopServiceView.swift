//
//  CoopServiceView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI
import QuickLook

struct CoopServiceView: View {
    
    @State var model = CoopServiceViewModel()
    
    @AppStorage(UserDefaultsKeys.saveCoopSchedule)
    var saveSchedule: Bool = true
    
    var body: some View {
        List {
            Section {
                makeLink(
                    url: "https://www.univcoop.jp/sit/index.html",
                    title: "芝浦工業大学消費生活協同組合"
                )
                
                makeLink(
                    url: "https://gakushoku.coop/",
                    title: "学食どっとコープ"
                )
            }
            
            Section {
                ForEach(model.coopSchedule, id: \.title) { schedule in
                    makeScheduleLink(
                        url: schedule.href,
                        title: schedule.title
                    )
                }
            } header: {
                Text("Label.CoopBusinessHours")
            }
        }
        .tint(Color.primary)
        .quickLookPreview($model.quickLookURL)
        .task {
            model.getCoopSchedule(saveLocal: saveSchedule)
        }
    }
    
    func makeLink(url: String, title: String) -> some View {
        LinkButton(URL(string: url)!) {
            Text(title)
        }
    }
    
    @ViewBuilder
    func makeScheduleLink(url: String, title: String) -> some View {
        if saveSchedule && !model.coopSchedule.isEmpty {
            Button {
                if let url = model.getFileURL(for: title) {
                    model.quickLookURL = url
                }
            } label: {
                Text(title)
            }
        } else {
            makeLink(url: url, title: title)
        }
    }
}

#Preview {
    CoopServiceView()
}
