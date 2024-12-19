//
//  HomeLinkCell.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/19.
//

import SwiftUI

struct HomeLinkCell: View {
    
    @ScaledMetric var iconSize = 17
    @ScaledMetric var padding = 4
    
    var title: LocalizedStringKey
    var symbol: String
    var trailingSymbol: String
    
    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Image(systemName: symbol)
                    .foregroundStyle(.accent)
            }
            .frame(width: iconSize)
            .padding(.trailing, padding)
            
            Text(title)
                
            Spacer()
            Image(systemName: trailingSymbol)
                .foregroundStyle(.secondary)
        }
        .fontWeight(.medium)
        .padding()
        .background()
    }
}

#Preview {
    HomeLinkCell(
        title: "Label.Loading",
        symbol: "camera",
        trailingSymbol: "chevron.right"
    )
}
