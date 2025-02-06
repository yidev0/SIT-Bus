//
//  BusPickerView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/20.
//

import SwiftUI

struct BusPickerView: View {
    
    @Binding var selectedBus: BusLineType
    
    var body: some View {
        Menu {
            Section {
                Picker(selection: $selectedBus) {
                    ForEach(BusLineType.SchoolBus.allCases, id: \.self) { type in
                        Label(type.localizedTitle, systemImage: type.symbol)
                            .tag(BusLineType.schoolBus(type))
                    }
                } label: {
                    Text(selectedBus.localizedTitle)
                }
            } header: {
                Text("Label.SchoolBus")
            }
            
            Section {
                Picker(selection: $selectedBus) {
                    ForEach(BusLineType.ShuttleBus.allCases, id: \.self) { type in
                        Label(type.localizedTitle, systemImage: type.symbol)
                            .tag(BusLineType.shuttleBus(type))
                    }
                } label: {
                    Text(selectedBus.localizedTitle)
                }
            } header: {
                Text("Label.ShuttleBus")
            }
        } label: {
            Text(selectedBus.localizedShortTitle)
        }
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
