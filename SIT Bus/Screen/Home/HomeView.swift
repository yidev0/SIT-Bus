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
                makeTimetable()
            }
        }
        .environment(model)
        .task {
            if Calendar.current.isDateInToday(timetableManager.lastUpdatedDate) == false {
                await timetableManager.loadData()
            }
            makeTimetable()
        }
    }
    
    func makeTimetable() {
        model.makeTimetable(from: timetableManager.data)
        model.startTasks()
    }
}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    
    HomeView()
        .environment(timetableManager)
}
