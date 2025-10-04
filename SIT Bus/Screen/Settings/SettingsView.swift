//
//  SettingsView.swift
//  School Bus
//
//  Created by Yuto on 2024/09/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.horizontalSizeClass)
    var horizontalSizeClass
    
    @Environment(TimetableManager.self)
    private var timetableManager
    
    @AppStorage(UserDefaultsKeys.openLinkInApp)
    var openLinkInApp: Bool = true
    
    @AppStorage(UserDefaultsKeys.hideGoogleCalendar)
    var hideCalendar: Bool = false
    
    @AppStorage(UserDefaultsKeys.saveCoopSchedule)
    var saveCoopSchedule: Bool = true
    
    @State var model = SettingsViewModel()
    @State var debugDate: Date = Date.now
    @State var includeDeviceInfo = true
    
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
                
                Section {
                    LinkButton(
                        model.makeFeedbackURL(include: includeDeviceInfo)
                    ) {
                        Label {
                            Text("Label.Feedback")
                                .foregroundStyle(Color.primary)
                        } icon: {
                            Image(systemName: "list.bullet.clipboard")
                        }
                    }
                    
                    Toggle(isOn: $includeDeviceInfo) {
                        VStack(alignment: .leading) {
                            Text("Label.IncludeDeviceInfo")
                            Text("Detail.IncludeDeviceInfo")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                
                Section("Label.AboutApp") {
                    Link(
                        destination: .appStore
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
                    
                    NavigationLink {
                        SettingsCreditsView()
                    } label: {
                        Label("Label.Credits", systemImage: "scroll")
                    }
                }
                
                Section("Label.InfoSource") {
                    LinkButton(.schoolBusOmiya) {
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
                    
                    LinkButton(.schoolBusIwatsuki) {
                        SettingsSourceLabel(
                            label: "Label.SchoolBusIwatsuki",
                            date: timetableManager.schoolBusIwatsuki?.lastUpdated,
                            format: .dateTime.year().month().day()
                        )
                    }
                    
                    LinkButton(.shuttleBus) {
                        SettingsSourceLabel(
                            label: "Label.ShuttleBus",
                            date: BusTimetable.shuttleBus.lastUpdated!,
                            format: .dateTime.year().month().day()
                        )
                    }
                }
            }
            .navigationTitle("Label.Settings")
            .toolbarTitleDisplayMode(.automatic)
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
