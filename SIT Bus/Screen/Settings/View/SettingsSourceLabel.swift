//
//  SettingsLink.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import SwiftUI

struct SettingsSourceLabel: View {
    
    let label: LocalizedStringKey
    let date: Date?
    let format: Date.FormatStyle
    
    init(label: LocalizedStringKey, date: Date?, format: Date.FormatStyle) {
        self.label = label
        self.date = date
        self.format = format
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
            if let date {
                Text(date, format: format)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text(verbatim: "N/A")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(Color.primary)
    }
}
