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
                                Label(type.localizedShortTitle, systemImage: type.symbol)
                            case .schoolIwatsuki:
                                Label(type.localizedShortTitle, systemImage: type.symbol)
                            case .shuttle:
                                Label(type.localizedShortTitle, systemImage: type.symbol)
                            }
                        }
                    }
                }
            }
        } label: {
            Text(selectedBus.localizedShortTitle)
                .padding(.horizontal, glassPadding ? 10 : 0)
                .padding(.vertical, glassPadding ? 4 : 0)
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
