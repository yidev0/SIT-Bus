//
//  ContentView.swift
//  School Bus
//
//  Created by Yuto on 2024/08/12.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(TimetableManager.self) private var timetableManager
    @State var showWelcome: Bool
    
    init() {
        showWelcome = !AppSettings().shownWelcome2
    }
    
    var body: some View {
        @Bindable var timetableManager = timetableManager
        
        TabView {
            HomeView()
                .tabItem {
                    Label(.home, systemImage: "house")
                        .symbolVariant(.fill)
                }
            
            TimetableView()
                .tabItem {
                    Label(.timetable, systemImage: "tablecells")
                        .symbolVariant(.fill)
                }
            
            SettingsView()
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
    }

}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    
    ContentView()
        .environment(timetableManager)
}
