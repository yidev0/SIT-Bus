//
//  SettingsLink.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import SwiftUI

struct SettingsLink: View {
    
    let url: URL
    let label: LocalizedStringKey
    let date: Date
    let format: Date.FormatStyle
    
    init(url: URL, label: LocalizedStringKey, date: Date, format: Date.FormatStyle) {
        self.url = url
        self.label = label
        self.date = date
        self.format = format
    }
    
    init(url: String, label: LocalizedStringKey, date: Date, format: Date.FormatStyle) {
        self.url = URL(string: url)!
        self.label = label
        self.date = date
        self.format = format
    }
    
    var body: some View {
        Link(destination: url) {
            VStack(alignment: .leading) {
                Text(label)
                Text(date, format: format)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(Color.primary)
        }
        .makeListLink()
    }
}
