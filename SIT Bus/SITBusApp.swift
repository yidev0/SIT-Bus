//
//  School_BusApp.swift
//  School Bus
//
//  Created by Yuto on 2024/08/12.
//

import SwiftUI
import SwiftData

@main
struct SITBusApp: App {
    
    @State var timetableManager = TimetableManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(timetableManager)
        }
    }
}
