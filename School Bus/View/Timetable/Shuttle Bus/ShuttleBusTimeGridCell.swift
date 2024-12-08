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
            Text(makeDate(), format: .dateTime.hour().minute())
                .presentationCompactAdaptation(.popover)
        }
        .accessibilityElement(children: .combine)
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
    }
    
    func makeDate() -> Date {
        let shuttleBusData = ShuttleBusData()
        let (hour, minute) = shuttleBusData.getDepartureTime(
            for: date,
            type: shuttleType
        )
        
        return Date.createDate(
            year: date.get(component: .year),
            month: date.get(component: .month),
            day: date.get(component: .day),
            hour: hour,
            minute: minute
        )!
    }
}
