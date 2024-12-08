//
//  CoopServiceView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI

struct CoopServiceView: View {
    
    @State var model = CoopServiceViewModel()
    
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
                    makeLink(
                        url: schedule.href,
                        title: schedule.title
                    )
                }
            } header: {
                Text("Label.CoopBusinessHours")
            }
        }
        .tint(Color.primary)
        .task {
            model.getCoopSchedule()
        }
    }
    
    func makeLink(url: String, title: String) -> some View {
        Link(destination: URL(string: url)!) {
            LabeledContent {
                Image(systemName: "arrow.up.right")
            } label: {
                Text(title)
            }
        }
    }
}

#Preview {
    CoopServiceView()
}
