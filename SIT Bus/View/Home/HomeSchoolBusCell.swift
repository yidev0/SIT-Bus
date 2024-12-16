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
    
    @State var nextBusDate: Date? = nil
    @State var note: LocalizedStringKey? = nil
    @State var nextBusText: LocalizedStringKey = ""
    
    @ScaledMetric var busFontSize = 24
    
    var body: some View {
        GroupBox {
            if let note {
                Text(note)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
            } else if let nextBusDate {
                HStack(alignment: .lastTextBaseline) {
                    Text(nextBusDate, format: .dateTime.hour().minute())
                        .monospacedDigit()
                        .font(.system(size: busFontSize, weight: .semibold))
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    Spacer()
                    
                    Text(nextBusText)
                }
                .contentTransition(.numericText())
                .accessibilityElement(children: .combine)
                .animation(.default, value: nextBusDate)
                .animation(.default, value: nextBusText)
            } else {
                HStack {
                    Text("Label.BusServiceEnded")
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    Spacer()
                }
            }
        } label: {
            Label {
                Text(type.localizedTitle)
            } icon: {
                Image(systemName: "bus.fill")
            }
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
        if let nextBusDate = data?.getNextBus(for: type, date: .now) {
            self.nextBusDate = nextBusDate
            let note = data?.getNextBusNote(for: type, date: .now)
            
            if let note, nextBusDate > note.start {
                self.note = "Label.\(Text(note.start, format: .dateTime.hour().minute()))to\(Text(note.end, format: .dateTime.hour().minute()))Service"
            } else {   
                let minutesRemaining = nextBusDate.convertToMinutes() - Date.now.convertToMinutes()
                
                if minutesRemaining < 0 {
                    self.nextBusText = "Label.DepartsIn0Minutes"
                } else {
                    self.nextBusText = "Label.DepartsIn\(minutesRemaining)Minutes"
                }
            }
        } else {
            self.nextBusDate = nil
            self.note = nil
        }
    }
}

#Preview {
    HomeSchoolBusCell(
        data: nil,
        type: .stationToCampus
    )
}
