//
//  TimetableInformationView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/29.
//

import SwiftUI

struct TimetableInformationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Detail.BusInfo")

                    LinkButton("http://bus.shibaura-it.ac.jp/developer.html") {
                        Text("Label.SchoolBus")
                            .font(.subheadline)
                            .foregroundStyle(Color.primary)
                    }
                    
                    LinkButton("https://www.shibaura-it.ac.jp/access/index.html#bus") {
                        Text("Label.ShuttleBus")
                            .font(.subheadline)
                            .foregroundStyle(Color.primary)
                    }
                    
                    LinkButton("https://www.shibaura-it.ac.jp/assets/jikoku_iwatsuki.pdf") {
                        Text("Label.SchoolBusIwatsuki")
                            .font(.subheadline)
                            .foregroundStyle(Color.primary)
                    }
                }
                
                Section {
                    Text("Detail.BusWheelchairInfo")
                } header: {
                    Label("Label.WheelchairInfo", systemImage: "wheelchair")
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: { dismiss.callAsFunction() }) {
                    Text("Label.Close")
                }
            }
        }
    }
}

#Preview {
    TimetableInformationView()
}
