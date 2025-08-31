//
//  BusPickerView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/20.
//

import SwiftUI

struct BusPickerView: View {
    
    @Binding var selectedBus: BusLineType
    var glassPadding = false
    
    var body: some View {
        Menu {
            ForEach(BusType.allCases, id: \.rawValue) { bus in
                Section(bus.localizedTitle) {
                    Picker(bus.localizedTitle, selection: $selectedBus) {
                        ForEach(bus.cases, id: \.self) { type in
                            switch bus {
                            case .schoolOmiya:
                                Label(type.localizedShortTitle, systemImage: "bus.fill")
                            case .schoolIwatsuki:
                                Label(type.localizedShortTitle, systemImage: "bus")
                            case .shuttle:
                                Label(type.localizedShortTitle, systemImage: "app.connected.to.app.below.fill")
                            }
                        }
                    }
                }
            }
        } label: {
            Text(selectedBus.localizedShortTitle)
                .padding(.horizontal, glassPadding ? 10 : nil)
                .padding(.vertical, glassPadding ? 4 : nil)
        }
        .labelsVisibility(.visible)
    }
}

#Preview {
    BusPickerView(
        selectedBus: .constant(
            .schoolBus(
                .campusToStation
            )
        )
    )
}
