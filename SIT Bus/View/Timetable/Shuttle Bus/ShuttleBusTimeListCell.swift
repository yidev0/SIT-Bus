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
                Text(date, style: .time)
                    .monospacedDigit()
            }
        }
    }
}

#Preview {
    ShuttleBusTimeListCell(
        date: .now,
        shuttleType: .toOmiya
    )
}
