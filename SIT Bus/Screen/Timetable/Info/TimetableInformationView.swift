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
                    Text(.busInfoDetail)

                    LinkButton("http://bus.shibaura-it.ac.jp/developer.html") {
                        Text(.schoolBus)
                            .font(.subheadline)
                            .foregroundStyle(Color.primary)
                    }
                    
                    LinkButton("https://www.shibaura-it.ac.jp/access/index.html#bus") {
                        Text(.shuttleBus)
                            .font(.subheadline)
                            .foregroundStyle(Color.primary)
                    }
                    
                    LinkButton("https://www.shibaura-it.ac.jp/access/index.html") {
                        Text(.schoolBusIwatsuki)
                            .font(.subheadline)
                            .foregroundStyle(Color.primary)
                    }
                }
                
                Section {
                    Text(.busWheelchairInfoDetail)
                } header: {
                    Label(.wheelchairInfo, systemImage: "wheelchair")
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                if #available(iOS 26.0, *) {
                    Button(role: .close) {
                        dismiss.callAsFunction()
                    }
                } else {
                    Button(action: { dismiss.callAsFunction() }) {
                        Text(.close)
                    }
                }
            }
        }
    }
}

#Preview {
    TimetableInformationView()
}
