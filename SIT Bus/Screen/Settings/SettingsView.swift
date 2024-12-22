//
//  SettingsView.swift
//  School Bus
//
//  Created by Yuto on 2024/09/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(TimetableManager.self) private var timetableManager
    @AppStorage(UserDefaultsKeys.openLinkInApp)
    var openLinkInApp: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $openLinkInApp) {
                        Text("Label.OpenLinkInApp")
                    }
                }
                
                Section("Label.AutoUpdateSource") {
                    LinkButton("http://bus.shibaura-it.ac.jp/developer.html") {
                        SettingsSourceLabel(
                            label: "Label.SchoolBus",
                            date: timetableManager.lastUpdatedDate,
                            format: .dateTime.year().month().day().hour().minute()
                        )
                    }
                    .makeListLink()
                    .contextMenu {
                        Button(role: .destructive) {
                            Task {
                                await timetableManager.loadData(forceFetch: true)
                            }
                        } label: {
                            Text("Label.ForceFetch")
                        }
                    }
                }
                    
                Section("Label.InfoSource") {
                    LinkButton("https://www.shibaura-it.ac.jp/access/index.html#bus") {
                        SettingsSourceLabel(
                            label: "Label.ShuttleBus",
                            date: Date.createDate(year: 2024, month: 9, day: 23)!,
                            format: .dateTime.year().month().day()
                        )
                    }
                    .makeListLink()
                    
                    LinkButton("https://www.shibaura-it.ac.jp/assets/jikoku_iwatsuki.pdf") {
                        SettingsSourceLabel(
                            label: "Label.SchoolBusIwatsuki",
                            date: .createDate(year: 2024, month: 9, day: 30)!,
                            format: .dateTime.year().month().day()
                        )
                    }
                    .makeListLink()
                }
                
                Section("Label.AboutApp") {
                    LinkButton(
                        "https://apps.apple.com/app/id6736679708"
                    ) {
                        Label {
                            HStack {
                                Text(verbatim: Bundle.main.appName ?? "")
                                Text(verbatim: "\(Bundle.main.releaseVersionNumber ?? "0.0")(\(Bundle.main.buildVersionNumber ?? "0"))")
                            }
                            .foregroundStyle(Color.primary)
                        } icon: {
                            Image(.appIconDisplay)
                                .clipShape(.rect(cornerRadius: 4))
                        }
                        .makeListLink()
                    }
                    
                    LinkButton(
                        "https://github.com/yidev0/School-Bus"
                    ) {
                        Label {
                            Text(verbatim: "GitHub")
                        } icon: {
                            Image(.githubFill)
                        }
                        .foregroundStyle(Color.primary)
                        .makeListLink()
                    }
                    
                    NavigationLink {
                        SettingsCreditsView()
                    } label: {
                        Label("Label.Credits", systemImage: "scroll")
                    }
                }
                
#if DEBUG
                Section {
                    
                }
#endif
                
            }
            .navigationTitle("Label.Settings")
            .listSectionSpacing(8)
        }
    }
}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    
    SettingsView()
        .environment(timetableManager)
}
