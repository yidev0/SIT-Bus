//
//  HomeBusCell.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/17.
//

import SwiftUI

struct HomeBusCellData {
    let date: Date?
    let note: LocalizedStringKey
}

struct HomeBusCell: View {
    
    @ScaledMetric var busFontSize = 24
    
    var type: BusLineType
    var date: Date?
    var currentDate: Date
    var note: LocalizedStringKey = "Label.NoBusService"
    
    init(
        type: BusLineType,
        data: HomeBusCellData,
        currentDate: Date = .now
    ) {
        self.type = type
        self.date = data.date
        self.currentDate = currentDate
        self.note = data.note
    }
    
    var body: some View {
        GroupBox {
            if let date {
                HStack(alignment: .lastTextBaseline) {
                    Text(date, format: .dateTime.hour().minute())
                        .monospacedDigit()
                        .font(.system(size: busFontSize, weight: .semibold))
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    Spacer()
                    
                    Text(makeRemainingTime(date: date))
                }
                .contentTransition(.numericText())
                .accessibilityElement(children: .combine)
            } else {
                HStack {
                    Text(note)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
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
        .backgroundStyle(Color.random)
    }
    
    func makeRemainingTime(date: Date) -> LocalizedStringKey {
        let remainingMinutes = date.convertToMinutes() - currentDate.convertToMinutes()
        if remainingMinutes >= 60 {
            return "Label.DepartsIn\(remainingMinutes/60)Hours"
        } else if remainingMinutes == 0 {
            return "Label.DepartsIn0Minutes"
        } else {
            return "Label.DepartsIn\(remainingMinutes)Minutes"
        }
    }
}

#Preview {
    HomeBusCell(
        type: .schoolBus(.campusToStation),
        data: .init(date: nil, note: "")
    )
}
