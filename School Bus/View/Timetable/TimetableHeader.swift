//
//  TimetableHeader.swift
//  School Bus
//
//  Created by Yuto on 2024/08/17.
//

import SwiftUI

struct TimetableHeader: View {
    
    var text: String
    var radius: Double
    
    init(text: String, radius: Double = 8) {
        self.text = text
        self.radius = radius
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .foregroundStyle(.tint)
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    TimetableHeader(text: "5")
}
