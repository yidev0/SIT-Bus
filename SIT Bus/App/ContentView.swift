//
//  ContentView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/12.
//

import SwiftUI
import SwiftData
import StoreKit

struct ContentView: View {

    @Environment(TimetableManager.self) private var timetableManager
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.requestReview) private var requestReview
    @State private var navigation = AppNavigation.shared
    @State var showWelcome: Bool
    
    init() {
        showWelcome = !AppSettings().shownWelcome2
    }
    
    var body: some View {
        @Bindable var timetableManager = timetableManager
        @Bindable var navigation = navigation
        
        TabView(selection: $navigation.selectedTab) {
            HomeView()
                .tag(AppTab.home)
                .tabItem {
                    Label(.home, systemImage: "house")
                        .symbolVariant(.fill)
                }
            
            TimetableView(navigationRequest: navigation.timetableRequest)
                .tag(AppTab.timetable)
                .tabItem {
                    Label(.timetable, systemImage: "tablecells")
                        .symbolVariant(.fill)
                }
            
            SettingsView()
                .tag(AppTab.settings)
                .tabItem {
                    Label(.settings, systemImage: "gear")
                        .symbolVariant(.fill)
                }
        }
        .sheet(isPresented: $showWelcome) {
            WelcomeView()
                .interactiveDismissDisabled()
        }
        .alert(
            isPresented: $timetableManager.showAlert
        ) {
            if let error = timetableManager.error {
                Alert(
                    title: Text(.fetchError),
                    message: Text(error.errorDescription!) ,
                    dismissButton: .default(Text(.close))
                )
            } else {
                Alert(
                    title: Text(.fetchError),
                    dismissButton: .default(Text(.close))
                )
            }
        }
        .onChange(of: canRequestReview, initial: true) { _, canRequest in
            if canRequest, timetableManager.consumeReviewRequest(isSceneActive: scenePhase == .active) {
                requestReview()
            }
        }
    }

    private var canRequestReview: Bool {
        timetableManager.reviewRequestPending && scenePhase == .active && !showWelcome && !timetableManager.showAlert
    }

}

enum AppTab: Hashable {
    case home
    case timetable
    case settings
}

struct TimetableNavigationRequest: Equatable {
    let line: BusLineType
    let date: Date
}

@MainActor
@Observable
final class AppNavigation {
    static let shared = AppNavigation()

    var selectedTab = AppTab.home
    var timetableRequest: TimetableNavigationRequest?

    func openTimetable(line: BusLineType, date: Date) {
        timetableRequest = TimetableNavigationRequest(line: line, date: date)
        selectedTab = .timetable
    }
}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    
    ContentView()
        .environment(timetableManager)
}
