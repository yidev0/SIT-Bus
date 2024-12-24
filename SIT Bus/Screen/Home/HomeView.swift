//
//  HomeView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/17.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(TimetableManager.self) private var timetableManager
    @State var model = HomeViewModel()
    
    @AppStorage("Show.SchoolBus.ToCampus") var showToCampus: Bool = true
    @AppStorage("Show.SchoolBus.ToStation") var showToStation: Bool = true
    @AppStorage("Show.ShuttleBus.ToToyosu") var showToToyosu: Bool = true
    @AppStorage("Show.ShuttleBus.ToOmiya") var showToOmiya: Bool = true
    
    var body: some View {
        @Bindable var model = model
        
        NavigationStack {
            ScrollView {
                HomeViewBusSection()
                    .padding(.bottom, 24)
                HomeViewLinkSection()
            }
            .contentMargins([.horizontal, .bottom], 16, for: .scrollContent)
            .contentMargins(.top, 8, for: .scrollContent)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Label.Home")
            .refreshable {
                await timetableManager.loadData()
                model.makeTimetable(
                    from: timetableManager.data,
                    date: .now
                )
            }
        }
        .environment(model)
        .sheet(isPresented: $model.showBusSelection) {
            HomeBusSelectionView(
                showToCampus: $showToCampus,
                showToStation: $showToStation,
                showToToyosu: $showToToyosu,
                showToOmiya: $showToOmiya
            )
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            model.makeTimetable(
                from: timetableManager.data,
                date: .now
            )
        }
        .onChange(of: timetableManager.data) { _, newValue in
            model.makeTimetable(
                from: newValue,
                date: .now
            )
        }
    }
}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    
    HomeView()
        .environment(timetableManager)
}
