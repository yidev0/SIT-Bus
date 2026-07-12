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
    @State var includeDeviceInfo = true
    
    var body: some View {
        @Bindable var timetableManager = timetableManager
        NavigationStack {
            List {
                Section(.options) {
                    Toggle(isOn: $openLinkInApp) {
                        Text(.openLinkInApp)
                    }
                }
                
                Section(.other) {
                    Toggle(isOn: $hideCalendar) {
                        Text(.hideGoogleCalendar)
                    }
                    
                    Toggle(isOn: $saveCoopSchedule) {
                        Text(.saveCoopSchedule)
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
                            Text(.deleteCache)
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
                            Text(.feedback)
                                .foregroundStyle(Color.primary)
                        } icon: {
                            Image(systemName: "list.bullet.clipboard")
                        }
                    }
                    
                    Toggle(isOn: $includeDeviceInfo) {
                        VStack(alignment: .leading) {
                            Text(.includeDeviceInfo)
                            Text(.includeDeviceInfoDetail)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                
                Section(.aboutApp) {
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
                        Label(.credits, systemImage: "scroll")
                    }
                }
                
                Section(.infoSource) {
                    LinkButton(.schoolBusOmiya) {
                        SettingsSourceLabel(
                            label: .schoolBusOmiya,
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
                            Text(.forceFetch)
                        }
                    }
                    
                    LinkButton(.schoolBusIwatsuki) {
                        SettingsSourceLabel(
                            label: .schoolBusIwatsuki,
                            date: timetableManager.schoolBusIwatsuki?.lastUpdated,
                            format: .dateTime.year().month().day()
                        )
                    }
                    
                    LinkButton(.shuttleBus) {
                        SettingsSourceLabel(
                            label: .shuttleBus,
                            date: BusTimetable.shuttleBus.lastUpdated!,
                            format: .dateTime.year().month().day()
                        )
                    }
                }
            }
            .navigationTitle(.settings)
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
