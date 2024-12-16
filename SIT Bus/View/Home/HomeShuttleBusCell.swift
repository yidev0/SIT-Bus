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
    @State var nextBusText: LocalizedStringKey = ""
    @State var noBusText: LocalizedStringKey = ""
    
    @ScaledMetric var busFontSize = 24
    
    init(type: BusLineType.ShuttleBus) {
        self.type = type
        self.shuttleBusData = ShuttleBusData()
    }
    
    var body: some View {
        GroupBox {
            if let date {
                HStack(alignment: .firstTextBaseline) {
                    Text(date, style: .time)
                        .monospacedDigit()
                        .font(.system(size: busFontSize, weight: .semibold))
                        .padding(.top, 8)
                        .padding(.top, 4)
                    
                    Spacer()
                    
                    Text(nextBusText)
                }
                .contentTransition(.numericText())
                .accessibilityElement(children: .combine)
            } else {
                HStack(spacing: 0) {
                    Text("Label.NoBusService")
                        .padding(.top, 8)
                        .padding(.top, 4)
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
        if let date = shuttleBusData.getDepartureDate(for: .now, type: type) {
            self.date = date
            
            if Date.now <= date {
                let remainingMinutes = date.convertToMinutes() - Date.now.convertToMinutes() 
                if remainingMinutes >= 60 {
                    nextBusText = "Label.DepartsIn\(remainingMinutes/60)Hours"
                } else if remainingMinutes == 0 {
                    nextBusText = "Label.DepartsIn0Minutes"
                } else {
                    nextBusText = "Label.DepartsIn\(remainingMinutes)Minutes"
                }
            } else {
                nextBusText = ""
                noBusText = "Label.BusServiceEnded"
            }
        } else {
            self.date = nil
            if shuttleBusData.isActive(.now) {
                noBusText = "Label.BusServiceEnded"
            } else {
                noBusText = "Label.NoBusService"
            }
        }
    }
    
}

#Preview {
    HomeShuttleBusCell(type: .toOmiya)
}
