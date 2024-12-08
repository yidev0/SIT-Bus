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
    
    var body: some View {
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
    }

}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    
    ContentView()
        .environment(timetableManager)
}
