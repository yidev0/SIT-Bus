//
//  HomeSchoolBusCell.swift
//  School Bus
//
//  Created by Yuto on 2024/08/21.
//

import SwiftUI

struct HomeSchoolBusCell: View {
    
    var timetable: SchoolBusTimetable?
    
    var type: BusLineType.SchoolBus
    var timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    @State var date: Date?
    @State var note: LocalizedStringKey
    @State var nextBusText: LocalizedStringKey
    
    @ScaledMetric var busFontSize = 24
    
    init(
        timetable: SchoolBusTimetable? = nil,
        type: BusLineType.SchoolBus
    ) {
        self.timetable = timetable
        self.type = type
        
        self.date = timetable?.getNextBus(for: .now)
        self.note = "Label.Loading"
        self.nextBusText = "Label.Loading"
    }
    
    var body: some View {
        GroupBox {
            if let date {
                HStack(alignment: .lastTextBaseline) {
                    Text(date, format: .dateTime.hour().minute())
                        .monospacedDigit()
                        .font(.system(size: busFontSize, weight: .semibold))
                        .padding(.top, 6)
                    
                    Spacer()
                    
                    Text(nextBusText)
                }
                .contentTransition(.numericText())
                .accessibilityElement(children: .combine)
                .animation(.default, value: date)
                .animation(.default, value: nextBusText)
            } else {
                HStack {
                    Text(note)
                        .padding(.top, 8)
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
        .onReceive(timer) { _ in
            loadNextBus()
        }
    }
    
    func loadNextBus() {
        if let nextBusDate = timetable?.getNextBus(for: .now) {
            self.date = nextBusDate
            let note = timetable?.getNextBusNote(for: .now, nextBusDate: nextBusDate)
            
            if let note, nextBusDate > note.start {
                self.date = nil
                self.note = "Label.\(Text(note.start, format: .dateTime.hour().minute()))to\(Text(note.end, format: .dateTime.hour().minute()))Service"
            } else {
                let remainingMinutes = nextBusDate.convertToMinutes() - Date.now.convertToMinutes()
                
                if remainingMinutes <= 0 {
                    self.nextBusText = "Label.DepartsIn0Minutes"
                } else if remainingMinutes >= 60 {
                    self.nextBusText = "Label.DepartsIn\(remainingMinutes/60)Hours"
                } else  {
                    self.nextBusText = "Label.DepartsIn\(remainingMinutes)Minutes"
                }
            }
        } else {
            self.date = nil
            if self.timetable == nil {
                self.note = "Label.NoBusService"
            } else {
                self.note = "Label.BusServiceEnded"
            }
        }
    }
}

#Preview {
    HomeSchoolBusCell(
        timetable: nil,
        type: .stationToCampus
    )
}
