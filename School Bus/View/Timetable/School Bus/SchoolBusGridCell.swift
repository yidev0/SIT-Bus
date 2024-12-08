//
//  TimetableCell.swift
//  School Bus
//
//  Created by Yuto on 2024/08/17.
//

import SwiftUI

struct SchoolBusGridCell: View {
    
    var hour: Int
    var minute: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .aspectRatio(1.414, contentMode: .fit)
                .hidden()
            Text(String(minute))
                .font(.body)
        }
        .accessibilityLabel(Text("\(hour):\(minute)"))
    }
}

#Preview {
    SchoolBusGridCell(hour: 4, minute: 24)
}
