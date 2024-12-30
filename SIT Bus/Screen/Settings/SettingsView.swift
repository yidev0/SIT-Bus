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
    
    @AppStorage(UserDefaultsKeys.hideGoogleCalendar)
    var hideCalendar: Bool = false
    
    @AppStorage(UserDefaultsKeys.saveCoopSchedule)
    var saveCoopSchedule: Bool = false
    
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
                    
                    NavigationLink {
                        SettingsCreditsView()
                    } label: {
                        Label("Label.Credits", systemImage: "scroll")
                    }
                
                    NavigationLink {
                        SettingsSourcesView(
                            lastUpdatedDate: timetableManager.lastUpdatedDate
                        )
                    } label: {
                        Label("Label.InfoSource", systemImage: "chevron.left.forwardslash.chevron.right")
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
                }
                
#if DEBUG
                Section {
                    Picker(selection: $timetableManager.error) {
                        ForEach(BusDataFetcherError.allCases, id: \.self) { error in
                            Text(error.errorDescription!)
                                .tag(error)
                        }
                    } label: {
                        Text(verbatim: "Error Type")
                    }

                    Button {
                        timetableManager.showAlert = true
                    } label: {
                        Text(verbatim: "Show Error")
                    }
                } header: {
                    Text(verbatim: "DEBUG")
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
