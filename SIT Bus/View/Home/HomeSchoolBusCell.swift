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
        .task {
            await loadNextEvent()
        }
    }
    
    func loadNextEvent() async {
        let baseTime = Date.now
        if let nextBusDate = timetable?.getNextBus(for: baseTime) {
            date = nextBusDate
            let note = timetable?.getNextBusNote(for: baseTime, nextBusDate: nextBusDate)
            
            if let note, nextBusDate > note.start {
                date = nil
                self.note = "Label.\(Text(note.start, format: .dateTime.hour().minute()))to\(Text(note.end, format: .dateTime.hour().minute()))Service"
                await scheduleNextEventUpdate(for: note.end, compareTo: baseTime)
            } else {
                let remainingMinutes = nextBusDate.convertToMinutes() - baseTime.convertToMinutes()
                
                if remainingMinutes <= 0 {
                    nextBusText = "Label.DepartsIn0Minutes"
                } else if remainingMinutes >= 60 {
                    nextBusText = "Label.DepartsIn\(remainingMinutes / 60)Hours"
                } else  {
                    nextBusText = "Label.DepartsIn\(remainingMinutes)Minutes"
                }
                
                await scheduleNextEventUpdate(for: nextBusDate, compareTo: baseTime)
            }
        } else {
            date = nil
            if timetable == nil {
                note = "Label.NoBusService"
            } else {
                note = "Label.BusServiceEnded"
            }
        }
    }
    
    func scheduleNextEventUpdate(for eventTime: Date, compareTo currentTime: Date) async {
        let timeInterval = eventTime.timeIntervalSince( currentTime)
        
        if timeInterval > 0 {
            try? await Task.sleep(for: .seconds(timeInterval))
            await loadNextEvent()
        }
    }
}

#Preview {
    HomeSchoolBusCell(
        timetable: nil,
        type: .stationToCampus
    )
}
