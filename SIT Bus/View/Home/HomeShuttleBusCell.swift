//
//  HomeShuttleBusCell.swift
//  School Bus
//
//  Created by Yuto on 2024/09/23.
//

import SwiftUI

struct HomeShuttleBusCell: View {
    
    @Environment(\.calendar) var calendar
    
    var type: BusLineType.ShuttleBus
    let shuttleBusData: ShuttleBusData
    
    @State var date: Date?
    @State var time: Date?
    
    init(type: BusLineType.ShuttleBus) {
        self.type = type
        self.shuttleBusData = ShuttleBusData()
        
        self._date = .init(initialValue: shuttleBusData.getNextDate(for: type))
        self.time = nil
    }
    
    var body: some View {
        GroupBox {
            if let date {
                // TODO: Next bus is not correct
                HStack(alignment: .firstTextBaseline) {
                    if calendar.isDate(.now, inSameDayAs: date) {
                        
                    } else {
                        Text(date, format: .dateTime.month().day())
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 8)
                            .padding(.top, 4)
                    }
                    
                    Spacer()
                    
                    // TODO: Show all time slots
                    if let time {
                        Text(time, format: .dateTime.hour().minute())
                            .monospacedDigit()
                    }
                }
                .contentTransition(.numericText())
                .accessibilityElement(children: .combine)
            } else {
                Text("Label.NoBusService")
            }
        } label: {
            Label(
                type.localizedTitle,
                systemImage: type.symbol
            )
        }
        .foregroundStyle(Color.primary)
        .onAppear {
            date = shuttleBusData.getNextDate(for: type)
            time = makeDate()
        }
    }
    
    func makeDate() -> Date? {
        guard let date = shuttleBusData.getNextDate(for: type) else { return nil }
        let shuttleBusData = ShuttleBusData()
        let (hour, minute) = shuttleBusData.getDepartureTime(
            for: date,
            type: type
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
    HomeShuttleBusCell(type: .toOmiya)
}
