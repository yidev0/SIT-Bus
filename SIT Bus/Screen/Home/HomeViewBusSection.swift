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
    
    @AppStorage("Show.SchoolBus") var showSchoolBus: Bool = true
    @AppStorage("Show.ShuttleBus") var showShuttleBus: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            if showSchoolBus {
                VStack(spacing: 8) {
                    ForEach(BusLineType.SchoolBus.allCases, id: \.rawValue) { type in
                        makeBusCell(for: type)
                    }
                }
            }
            
            if showShuttleBus {
                VStack(spacing: 8) {
                    ForEach(BusLineType.ShuttleBus.allCases, id: \.rawValue) { type in
                        makeBusCell(for: type)
                    }
                }
            }
            
            Menu {
                Toggle(isOn: $showSchoolBus) {
                    Label(
                        "Label.SchoolBus",
                        systemImage: "bus.fill"
                    )
                }
                
                Toggle(isOn: $showShuttleBus) {
                    Label(
                        "Label.ShuttleBus",
                        systemImage: "app.connected.to.app.below.fill"
                    )
                }
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
        .animation(.default, value: showSchoolBus)
        .animation(.default, value: showShuttleBus)
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
    func makeBusCell<T: BusLine>(for type: T) -> some View {
        NavigationLink(value: type) {
            HomeBusCell(
                type: type,
                state: model.getBusState(for: type)
            )
        }
        .buttonStyle(.home)
        //        .contextMenu {
        //            Button {
        //                model.startLiveActivity(for: type)
        //            } label: {
        //                Text(verbatim: "Start Live Activity")
        //            }
        //        }
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
