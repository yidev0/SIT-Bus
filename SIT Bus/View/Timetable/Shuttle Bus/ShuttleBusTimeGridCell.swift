//
//  ShuttleBusTimeGridCell.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import Foundation
import SwiftUICore

struct ShuttleBusTimeGridCell: View {
    
    let date: Date
    let shuttleType: BusLineType.ShuttleBus
    @State var showPopover: Bool = false
    
    var body: some View {
        VStack {
            Text(date, format: .dateTime.day())
            Text(date, format: .dateTime.weekday())
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .onTapGesture {
            showPopover = true
        }
        .popover(isPresented: $showPopover) {
            Text(date, style: .time)
                .presentationCompactAdaptation(.popover)
        }
        .accessibilityElement(children: .combine)
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
    }
}
