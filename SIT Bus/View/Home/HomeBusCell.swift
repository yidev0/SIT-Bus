//
//  HomeBusCell.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/28.
//

import SwiftUI

enum HomeBusCellState: Equatable {
    case loading
    case nextBus(date: Date, departsIn: Int)
    case timely(start: Date, end: Date)
    case busServiceEnded
    case noBusService
    
    func makeTimeInterval(currentTime: Date) -> TimeInterval? {
        switch self {
        case .nextBus(let date, _):
            let calendar = Calendar.current
            let interval = date.timeIntervalSince(currentTime)
            
            if interval >= 3600 {
                var targetDate = calendar.date(byAdding: .hour, value: 1, to: currentTime)!
                targetDate = calendar.date(bySetting: .minute, value: 0, of: targetDate)!
                targetDate = calendar.date(bySetting: .second, value: 0, of: targetDate)!
                return targetDate.timeIntervalSince(currentTime)
            } else {
                var targetDate = calendar.date(byAdding: .minute, value: 1, to: currentTime)!
                targetDate = calendar.date(bySetting: .second, value: 0, of: targetDate)!
                return targetDate.timeIntervalSince(currentTime)
            }
        case .timely(_, let end):
            return end.timeIntervalSince(currentTime)
        case .busServiceEnded, .noBusService:
            return nil
//            var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentTime)!
//            tomorrow = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) ?? currentTime
//            return tomorrow.timeIntervalSince(currentTime)
        case .loading:
            return nil
        }
    }
}

struct HomeBusCell<T: BusType>: View {
    
    @ScaledMetric var busFontSize = 24
    @ScaledMetric var timelyFontSize = 20
    
    let type: T
    let state: HomeBusCellState
    
    var body: some View {
        GroupBox {
            HStack(alignment: .lastTextBaseline) {
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
                
                Spacer()
                
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
            .contentTransition(.numericText())
            .accessibilityElement(children: .combine)
            .animation(.default, value: state)
            .padding(.top, 6)
        } label: {
            Label {
                Text(type.localizedTitle)
            } icon: {
                Image(systemName: type.symbol)
            }
        }
        .foregroundStyle(Color.primary)
    }
}

#Preview {
    HomeBusCell(
        type: BusLineType.SchoolBus.campusToStation,
        state: .nextBus(date: .now, departsIn: 5)
    )
    
    HomeBusCell(
        type: BusLineType.SchoolBus.campusToStation,
        state: .timely(start: .now, end: .distantFuture)
    )
    
    HomeBusCell(
        type: BusLineType.SchoolBus.campusToStation,
        state: .busServiceEnded
    )
    
    HomeBusCell(
        type: BusLineType.SchoolBus.campusToStation,
        state: .noBusService
    )
}
