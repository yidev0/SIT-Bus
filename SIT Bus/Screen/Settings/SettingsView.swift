//
//  SettingsView.swift
//  School Bus
//
//  Created by Yuto on 2024/09/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(TimetableManager.self)
    private var timetableManager
    
    @AppStorage(UserDefaultsKeys.openLinkInApp)
    var openLinkInApp: Bool = true
    
    @AppStorage(UserDefaultsKeys.hideGoogleCalendar)
    var hideCalendar: Bool = false
    
    @AppStorage(UserDefaultsKeys.saveCoopSchedule)
    var saveCoopSchedule: Bool = true
    
    @State var model = SettingsViewModel()
    
    var body: some View {
        @Bindable var timetableManager = timetableManager
        NavigationStack {
            List {
                Section("Label.Options") {
                    Toggle(isOn: $openLinkInApp) {
                        Text("Label.OpenLinkInApp")
                    }
                }
                
                Section("Label.Other") {
                    Toggle(isOn: $hideCalendar) {
                        Text("Label.HideGoogleCalendar")
                    }
                    
                    Toggle(isOn: $saveCoopSchedule) {
                        Text("Label.SaveCoopSchedule")
                    }
                    
                    Button {
                        model.deleteCache()
                    } label: {
                        LabeledContent {
                            if model.deletingCache {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else if let cacheSize = model.cacheSize {
                                Text("\(cacheSize, specifier: "%.2f") MB")
                                    .font(.subheadline)
                            }
                        } label: {
                            Text("Label.DeleteCache")
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .disabled(model.deletingCache)
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
                    }
                    
                    LinkButton(
                        "https://tally.so/r/mDY9yb"
                    ) {
                        Label {
                            Text("Label.Feedback")
                                .foregroundStyle(Color.primary)
                        } icon: {
                            Image(systemName: "list.bullet.clipboard")
                        }
                    }
                    
                    NavigationLink {
                        SettingsCreditsView()
                    } label: {
                        Label("Label.Credits", systemImage: "scroll")
                    }
                }
                
                Section("Label.InfoSource") {
                    LinkButton("http://bus.shibaura-it.ac.jp/db/bus_data.json") {
                        SettingsSourceLabel(
                            label: "Label.SchoolBusOmiya",
                            date: timetableManager.lastUpdatedDate,
                            format: .dateTime.year().month().day().hour().minute()
                        )
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            Task {
                                await timetableManager.loadData(forceFetch: true)
                            }
                        } label: {
                            Text("Label.ForceFetch")
                        }
                    }
                    
                    LinkButton("https://www.shibaura-it.ac.jp/assets/zikokuhyou.pdf") {
                        SettingsSourceLabel(
                            label: "Label.SchoolBusIwatsuki",
                            date: timetableManager.schoolBusIwatsuki?.lastUpdated,
                            format: .dateTime.year().month().day()
                        )
                    }
                    
                    LinkButton("https://www.shibaura-it.ac.jp/access/index.html#bus") {
                        SettingsSourceLabel(
                            label: "Label.ShuttleBus",
                            date: BusTimetable.shuttleBus.lastUpdated!,
                            format: .dateTime.year().month().day()
                        )
                    }
                }
            }
            .navigationTitle("Label.Settings")
            .navigationBarTitleDisplayMode(UIDevice.current.userInterfaceIdiom == .pad ? .inline : .automatic)
            .listSectionSpacing(8)
        }
        .onAppear {
            model.updateCacheSize()
        }
    }
}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    
    SettingsView()
        .environment(timetableManager)
}
