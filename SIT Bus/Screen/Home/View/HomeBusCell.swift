//
//  HomeBusCell.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/28.
//

import SwiftUI

struct HomeBusCell: View {
    
    @ScaledMetric var busFontSize = 24
    @ScaledMetric var timelyFontSize = 20
    
    let type: BusLineType
    let state: NextBusState
    
    var body: some View {
        GroupBox {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .lastTextBaseline) {
                    nextBusTime
                    Spacer()
                    countDown
                }
                
                VStack(alignment: .leading) {
                    nextBusTime
                    countDown
                }
            }
            .contentTransition(.numericText())
            .accessibilityElement(children: .combine)
            .animation(.default, value: state)
            .padding(.top, 6)
        } label: {
            Label {
                Text(type.localizedShortTitle)
            } icon: {
                Image(systemName: type.symbol)
            }
        }
        .foregroundStyle(Color.primary)
    }
    
    @ViewBuilder
    var nextBusTime: some View {
        switch state {
        case .nextBus(let date, _):
            Text(date, format: .dateTime.hour().minute())
                .monospacedDigit()
                .font(.system(size: busFontSize, weight: .semibold))
        case .timely(let start, let end):
            Text("Label.\(Text(start, format: .dateTime.hour().minute()))to\(Text(end, format: .dateTime.hour().minute()))Service")
                .font(.title3)
        case .busServiceEnded:
            Text("Label.BusServiceEnded")
        case .noBusService:
            Text("Label.NoBusService")
        case .loading:
            Text("Label.Loading")
        }
    }
    
    @ViewBuilder
    var countDown: some View {
        switch state {
        case .nextBus(_, let departsIn):
            if departsIn <= 0 {
                Text("Label.DepartsIn0Minutes")
            } else if departsIn >= 60 {
                Text("Label.DepartsIn\(departsIn / 60)Hours")
            } else  {
                Text("Label.DepartsIn\(departsIn)Minutes")
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    HomeBusCell(
        type: .schoolBus(.campusToStation),
        state: .nextBus(date: .now, departsIn: 5)
    )
    
    HomeBusCell(
        type: .schoolBus(.campusToStation),
        state: .timely(start: .now, end: .distantFuture)
    )
    
    HomeBusCell(
        type: .schoolBus(.campusToStation),
        state: .busServiceEnded
    )
    
    HomeBusCell(
        type: .schoolBus(.campusToStation),
        state: .noBusService
    )
}
