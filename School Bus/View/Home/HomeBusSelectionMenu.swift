//
//  HomeBusSelectionMenu.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import SwiftUI

struct HomeBusSelectionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var showToCampus: Bool
    @Binding var showToStation: Bool
    @Binding var showToToyosu: Bool
    @Binding var showToOmiya: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    makeSchoolBusCell(
                        for: .stationToCampus,
                        show: $showToCampus
                    )
                    makeSchoolBusCell(
                        for: .campusToStation,
                        show: $showToStation
                    )
                } header: {
                    Text("Label.SchoolBus")
                }
                
                Section {
                    makeShuttleBusCell(
                        type: .toToyosu,
                        show: $showToToyosu
                    )
                    makeShuttleBusCell(
                        type: .toOmiya,
                        show: $showToOmiya
                    )
                } header: {
                    Text("Label.ShuttleBus")
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Button.Done")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeSchoolBusCell(
        for type: BusLineType.SchoolBus,
        show: Binding<Bool>
    ) -> some View {
        Button {
            show.wrappedValue.toggle()
        } label: {
            Label(type.localizedTitle, systemImage: type.symbol)
                .tag(BusLineType.schoolBus(type))
                .foregroundStyle(Color.primary)
        }
        .selectionIndicator(
            selected: show.wrappedValue,
            alignment: .leading,
            spacing: 16
        )
    }
    
    @ViewBuilder
    private func makeShuttleBusCell(
        type: BusLineType.ShuttleBus,
        show: Binding<Bool>
    ) -> some View {
        Button {
            show.wrappedValue.toggle()
        } label: {
            Label(type.localizedTitle, systemImage: type.symbol)
                .tag(BusLineType.shuttleBus(type))
                .foregroundStyle(Color.primary)
        }
        .selectionIndicator(
            selected: show.wrappedValue,
            alignment: .leading,
            spacing: 16
        )
    }
        
}

#Preview {
    @Previewable @State var showToCampus: Bool = true
    @Previewable @State var showToStation: Bool = true
    @Previewable @State var showToToyosu: Bool = true
    @Previewable @State var showToOmiya: Bool = true
    
    HomeBusSelectionView(
        showToCampus: $showToCampus,
        showToStation: $showToStation,
        showToToyosu: $showToToyosu,
        showToOmiya: $showToOmiya
    )
}
