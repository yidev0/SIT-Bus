//
//  HomeSchoolBusCell.swift
//  School Bus
//
//  Created by Yuto on 2024/08/21.
//

import SwiftUI

struct HomeSchoolBusCell: View {
    
    var data: SBReferenceData?
    
    var type: BusLineType.SchoolBus
    var timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    @State var nextBusHour: Int? = nil
    @State var nextBusMinute: Int? = nil
    @State var note: LocalizedStringKey? = nil
    @State var nextBusText: LocalizedStringKey = ""
    
    @State var busArray: [Date] = []
    
    var body: some View {
        GroupBox {
            if let nextBusHour, let nextBusMinute {
                HStack(alignment: .lastTextBaseline) {
                    Text("\(String(format: "%02d", nextBusHour)):\(String(format: "%02d", nextBusMinute))")
                        .monospacedDigit()
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    Spacer()
                    
                    Text(nextBusText)
                }
                .contentTransition(.numericText())
                .accessibilityElement(children: .combine)
                .animation(.default, value: nextBusHour)
                .animation(.default, value: nextBusMinute)
                .animation(.default, value: nextBusText)
                
                if let note {
                    Divider()
                    Text(note)
                        .padding(.top, 4)
                }
            } else {
                HStack {
                    Text("Label.NoBusService")
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    Spacer()
                }
            }
        } label: {
            Label(
                type.localizedTitle,
                systemImage: "bus.fill"
            )
        }
        .foregroundStyle(Color.primary)
        .onAppear {
            loadNextBus()
        }
        .onReceive(timer) { _ in
            loadNextBus()
        }
    }
    
    func loadNextBus() {
        if let (hour, minute) = data?.getNextBus(for: type, date: .now) {
            self.nextBusHour = hour
            self.nextBusMinute = minute
            
            let nextBusTime = hour * 60 + minute
            let currentTime = Date.now.get(component: .hour) * 60 + Date.now.get(component: .minute)
            
            let minutesRemaining = (nextBusTime - currentTime)
            if minutesRemaining < 0 {
                self.nextBusText = "Label.DepartsIn0Minutes"
            } else {
                self.nextBusText = "Label.DepartsIn\(minutesRemaining)Minutes"
            }
            
            self.note = data?.getBusNote(for: type, date: .now)
        } else {
            self.nextBusHour = nil
            self.nextBusMinute = nil
            self.note = nil
            self.nextBusText = "Label.FinalBus"
        }
    }
}

#Preview {
    HomeSchoolBusCell(
        data: nil,
        type: .stationToCampus
    )
}
