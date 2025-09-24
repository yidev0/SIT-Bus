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
        showWelcome = !UserDefaults.standard.bool(forKey: UserDefaultsKeys.shownWelcome2)
    }
    
    var body: some View {
        @Bindable var timetableManager = timetableManager
        
        TabView {
            HomeView()
                .tabItem {
                    Label("Label.Home", systemImage: "house")
                        .symbolVariant(.fill)
                }
            
            TimetableView()
                .tabItem {
                    Label("Label.Timetable", systemImage: "tablecells")
                        .symbolVariant(.fill)
                }
            
            SettingsView()
                .tabItem {
                    Label("Label.Settings", systemImage: "gear")
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
                    title: Text("Label.FetchError"),
                    message: Text(error.errorDescription!) ,
                    dismissButton: .default(Text("Label.Close"))
                )
            } else {
                Alert(
                    title: Text("Label.FetchError"),
                    dismissButton: .default(Text("Label.Close"))
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
