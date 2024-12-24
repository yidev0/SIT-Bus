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
    
    var timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    @State var date: Date?
    @State var note: LocalizedStringKey
    @State var nextBusText: LocalizedStringKey
    
    @ScaledMetric var busFontSize = 24
    
    init(type: BusLineType.ShuttleBus) {
        self.type = type
        self.shuttleBusData = ShuttleBusData()
        self.date = shuttleBusData.getDepartureDate(for: .now, type: type)
        
        self.note = "Label.Loading"
        self.nextBusText = "Label.Loading"
    }
    
    var body: some View {
        GroupBox {
            if let date {
                HStack(alignment: .firstTextBaseline) {
                    Text(date, style: .time)
                        .monospacedDigit()
                        .font(.system(size: busFontSize, weight: .semibold))
                        .padding(.top, 6)
                    
                    Spacer()
                    
                    Text(nextBusText)
                }
                .contentTransition(.numericText())
                .accessibilityElement(children: .combine)
            } else {
                HStack(spacing: 0) {
                    Text(note)
                        .padding(.top, 8)
                    Spacer()
                }
            }
        } label: {
            Label {
                Text(type.localizedTitle)
            } icon: {
                Image(systemName: type.symbol)
            }
        }
        .foregroundStyle(Color.primary)
        .onAppear {
            checkBusData()
        }
        .onReceive(timer) { _ in
            checkBusData()
        }
    }
    
    func checkBusData() {
        let baseTime = Date.now
        if let date = shuttleBusData.getDepartureDate(
            for: baseTime,
            type: type
        ) {
            self.date = date
            
            if baseTime <= date {
                let remainingMinutes = date.convertToMinutes() - baseTime.convertToMinutes()
                if remainingMinutes >= 60 {
                    nextBusText = "Label.DepartsIn\(remainingMinutes/60)Hours"
                } else if remainingMinutes == 0 {
                    nextBusText = "Label.DepartsIn0Minutes"
                } else {
                    nextBusText = "Label.DepartsIn\(remainingMinutes)Minutes"
                }
            } else {
                self.date = nil
                note = "Label.BusServiceEnded"
            }
        } else {
            self.date = nil
            if shuttleBusData.isActive(baseTime) {
                note = "Label.BusServiceEnded"
            } else {
                note = "Label.NoBusService"
            }
        }
    }
    
}

#Preview {
    HomeShuttleBusCell(
        type: .toOmiya
    )
}
