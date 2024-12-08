//
//  ShuttleBusTimeListCell.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import Foundation
import SwiftUI

struct ShuttleBusTimeListCell: View {
    
    let date: Date
    let shuttleType: BusLineType.ShuttleBus
    
    var body: some View {
        GroupBox {
            HStack(alignment: .firstTextBaseline) {
                Text(date, format: .dateTime.month().day().weekday())
                    .fontWeight(.semibold)
                Spacer()
                Text(makeDate(), format: .dateTime.hour().minute())
                    .monospacedDigit()
            }
        }
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

#Preview {
    ShuttleBusTimeListCell(
        date: .now,
        shuttleType: .toOmiya
    )
}
