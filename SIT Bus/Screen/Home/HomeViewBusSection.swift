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
//                if showToCampus {
//                    makeSchoolBusCell(for: .stationToCampus)
//                }
//                
//                if showToStation {
//                    makeSchoolBusCell(for: .campusToStation)
//                }
                
                ForEach(BusLineType.SchoolBus.allCases, id: \.rawValue) { type in
                    makeBusCell(for: type)
                }
            }
            .animation(.default, value: showToCampus)
            .animation(.default, value: showToStation)
            
            VStack(spacing: 8) {
//                if showToToyosu {
//                    makeShuttleBusCell(for: .toToyosu)
//                }
//                
//                if showToOmiya {
//                    makeShuttleBusCell(for: .toOmiya)
//                }
//                
                ForEach(BusLineType.ShuttleBus.allCases, id: \.rawValue) { type in
                    makeBusCell(for: type)
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
        .navigationDestination(for: BusLineType.SchoolBus.self) { type in
            SchoolBusListView(
                timetable: model.getTimetable(for: type)
            )
            .backgroundStyle(Color(.secondarySystemGroupedBackground))
            .background(Color(.systemGroupedBackground))
        }
        .navigationDestination(for: BusLineType.ShuttleBus.self) { type in
            ShuttleBusTimeTable(
                listType: .list,
                shuttleType: type
            )
            .backgroundStyle(Color(.secondarySystemGroupedBackground))
            .background(Color(.systemGroupedBackground))
        }
    }
    
    @ViewBuilder
    func makeBusCell<T: BusType>(for type: T) -> some View {
        NavigationLink(value: type) {
            HomeBusCell(
                type: type,
                state: model.getBusState(for: type)
            )
        }
        .buttonStyle(.home)
    }
    
    @ViewBuilder
    func makeSchoolBusCell(for type: BusLineType.SchoolBus) -> some View {
        NavigationLink {
            SchoolBusListView(
                timetable: model.getTimetable(for: type)
            )
            .backgroundStyle(Color(.secondarySystemGroupedBackground))
            .background(Color(.systemGroupedBackground))
        } label: {
            HomeSchoolBusCell(
                timetable: model.getTimetable(for: type),
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
