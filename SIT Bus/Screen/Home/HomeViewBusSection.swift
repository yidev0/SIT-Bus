//
//  HomeViewBusSection.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI

struct HomeViewBusSection: View {
    
    @Environment(\.horizontalSizeClass)
    var sizeClass
    
    @Environment(TimetableManager.self)
    private var timetableManager
    
    @AppStorage("Show.SchoolBus")
    var showSchoolBus: Bool = true
    
    @AppStorage("Show.SchoolBusIwatsuki")
    var showSchoolBusIwatsuki: Bool = false
    
    @AppStorage("Show.ShuttleBus")
    var showShuttleBus: Bool = true
    
    var body: some View {
        VStack(
            alignment: sizeClass == .compact ? .center : .leading,
            spacing: 16
        ) {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 350 - 32))],
                alignment: .leading,
                spacing: 8
            ) {
                ForEach(BusType.allCases) { type in
                    switch type {
                    case .schoolOmiya:
                        if showSchoolBus {
                            makeBusSection(for: type)
                        } else {
                            EmptyView()
                        }
                    case .schoolIwatsuki:
                        if showSchoolBusIwatsuki {
                            makeBusSection(for: type)
                        } else {
                            EmptyView()
                        }
                    case .shuttle:
                        if showShuttleBus {
                            makeBusSection(for: type)
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            
            Menu {
                Toggle(isOn: $showSchoolBus) {
                    Label(
                        BusType.schoolOmiya.localizedTitle,
                        systemImage: BusType.schoolOmiya.symbol
                    )
                }
                
                Toggle(isOn: $showSchoolBusIwatsuki) {
                    Label(
                        BusType.schoolIwatsuki.localizedTitle,
                        systemImage: BusType.schoolIwatsuki.symbol
                    )
                    Text("Detail.SchoolBusIwatsuki")
                }
                
                Toggle(isOn: $showShuttleBus) {
                    Label(
                        BusType.shuttle.localizedTitle,
                        systemImage: BusType.shuttle.symbol
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
            .buttonBorderShape(.capsule)
        }
        .animation(.default, value: showSchoolBus)
        .animation(.default, value: showSchoolBusIwatsuki)
        .animation(.default, value: showShuttleBus)
        .navigationDestination(for: BusLineType.self) { type in
            SchoolBusListView(
                table: timetableManager.getTable(type: type, date: .now),
                for: type.destinationType
            )
        }
    }
    
    @ViewBuilder
    func makeBusSection(for type: BusType) -> some View {
        Section {
            ForEach(type.cases, id: \.self) { type in
                makeBusCell(for: type)
            }
        } header: {
            Text(type.localizedTitle)
                .font(.headline)
                .padding([.top, .leading], 4)
        }
    }
    
    @ViewBuilder
    func makeBusCell(for type: BusLineType) -> some View {
        NavigationLink(value: type) {
            HomeBusCell(
                type: type,
                state: timetableManager.getBusState(for: type)
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
