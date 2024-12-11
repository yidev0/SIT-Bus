//
//  HomeViewBusSection.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI

struct HomeViewBusSection: View {
    
    @Environment(HomeViewModel.self) private var model
    @Environment(TimetableManager.self) private var timetableManager
    
    @AppStorage("Show.SchoolBus.ToCampus") var showToCampus: Bool = true
    @AppStorage("Show.SchoolBus.ToStation") var showToStation: Bool = true
    @AppStorage("Show.ShuttleBus.ToToyosu") var showToToyosu: Bool = true
    @AppStorage("Show.ShuttleBus.ToOmiya") var showToOmiya: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                if showToCampus {
                    makeSchoolBusCell(for: .stationToCampus)
                }
                
                if showToStation {
                    makeSchoolBusCell(for: .campusToStation)
                }
            }
            .animation(.default, value: showToCampus)
            .animation(.default, value: showToStation)
            
            VStack(spacing: 8) {
                if showToToyosu {
                    makeShuttleBusCell(for: .toToyosu)
                }
                
                if showToOmiya {
                    makeShuttleBusCell(for: .toOmiya)
                }
            }
            .animation(.default, value: showToToyosu)
            .animation(.default, value: showToOmiya)
            
            Button {
                model.showBusSelection = true
            } label: {
                Text("Label.Edit")
                    .foregroundStyle(.accent)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background()
            }
            .buttonStyle(.home)
            .clipShape(.capsule)
        }
    }
    
    func makeSchoolBusCell(for type: BusLineType.SchoolBus) -> some View {
        NavigationLink {
            SchoolBusListView(
                timesheet: model.makeTimeTable(
                    for: type,
                    with: timetableManager.data
                )
            )
            .backgroundStyle(Color(.secondarySystemGroupedBackground))
            .background(Color(.systemGroupedBackground))
        } label: {
            HomeSchoolBusCell(
                data: timetableManager.data,
                type: type
            )
        }
        .id(type)
        .buttonStyle(.home)
//        .contextMenu {
//            Button {
//                model.startLiveActivity(for: type)
//            } label: {
//                Text(verbatim: "Start Live Activity")
//            }
//        }
    }
    
    func makeShuttleBusCell(for type: BusLineType.ShuttleBus) -> some View {
        NavigationLink {
            ShuttleBusTimeTable(
                listType: .list,
                shuttleType: type
            )
            .backgroundStyle(Color(.secondarySystemGroupedBackground))
            .background(Color(.systemGroupedBackground))
        } label: {
            HomeShuttleBusCell(
                type: type
            )
        }
        .id(type)
        .buttonStyle(.home)
    }
        
}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    @Previewable @State var model = HomeViewModel()
    
    ScrollView {
        HomeViewBusSection()
    }
    .background(Color(.systemGroupedBackground))
    .environment(timetableManager)
    .environment(model)
}
