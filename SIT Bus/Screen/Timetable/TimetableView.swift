//
//  TimetableView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import SwiftUI

struct TimetableView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var model = TimetableViewModel()
    @Environment(TimetableManager.self) private var timetableManager
    
    var body: some View {
        @Bindable var model = model
        
        NavigationStack {
            ZStack {
                switch horizontalSizeClass {
                case .regular:
                    switch model.timesheetBusType {
                    case .schoolOmiya:
                        if model.isActiveDate {
                            horizontalTimetable
                        } else {
                            ContentUnavailableView(
                                "Label.NoBuses",
                                systemImage: "exclamationmark.triangle.fill"
                            )
                        }
                    case .shuttle, .schoolIwatsuki:
                        horizontalTimetable
                    }
                default:
                    TimetableContentView(
                        table: model.timetable?.getTable(for: model.date),
                        for: model.timesheetBus,
                        date: model.date
                    )
                }
            }
            .safeAreaInset(edge: .bottom) {
                switch horizontalSizeClass {
                case .compact:
                    HStack(spacing: 12) {
                        switch model.timesheetBusType {
                        case .schoolOmiya, .schoolIwatsuki:
                            Button {
                                model.showTimesheetDatePicker = true
                            } label: {
                                Text(model.date, format: .dateTime.day().month().weekday())
                            }
                            .matchedTransitionSource(id: "DatePicker", in: namespace)
                        case .shuttle:
                            EmptyView()
                        }
                        
                        BusPickerView(
                            selectedBus: $model.timesheetBus
                        )
                    }
                    .padding(.bottom, 16)
                    .buttonStyle(.filter)
                default:
                    EmptyView()
                }
            }
            .navigationTitle("Label.Timetable")
            .navigationBarTitleDisplayMode(UIDevice.current.userInterfaceIdiom == .pad ? .inline : .automatic)
            .background(Color(.systemGroupedBackground))
            .animation(.default, value: model.timesheetBus)
            .onChange(of: model.timesheetBus) { _, _ in
                updateTimesheet()
            }
            .onChange(of: model.date) { _, _ in
                updateTimesheet()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        model.sheet = .information
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel("Label.Accessiblity.Information")
                    .matchedTransitionSource(id: "Information", in: namespace)
                }
                
                if horizontalSizeClass == .regular {
                    ToolbarItem(placement: .topBarLeading) {
                        Picker(selection: $model.timesheetBusType) {
                            ForEach(BusType.allCases, id: \.rawValue) { type in
                                Label(type.localizedTitle, systemImage: type.symbol)
                                    .tag(type)
                            }
                        } label: {
                            Text(model.timesheetBusType.localizedTitle)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        switch model.timesheetBusType {
                        case .schoolOmiya:
                            DatePickerButton(
                                selectedDate: $model.timesheetDate,
                                showPicker: $model.showTimesheetDatePicker,
                                showFullPicker: $model.showFullTimesheetDatePicker,
                                activeDates: timetableManager.data?.getActiveDays() ?? []
                            )
                            .fontWeight(.semibold)
                        case .schoolIwatsuki:
                            Picker(selection: $model.isWeekday) {
                                Text("Label.Weekday")
                                    .tag(true)
                                Text("Label.Saturday")
                                    .tag(false)
                            } label: {
                                Text("Label.ScheduleType")
                            }
                            .fontWeight(.semibold)
                        case .shuttle:
                            EmptyView()
                        }
                    }
                }
            }
            .sheet(isPresented: $model.showInfoSheet) {
                TimetableInformationView()
            }
            .fullScreenCover(isPresented: $model.showFullTimesheetDatePicker) {
                TimetableFullDatePickerView(
                    date: $model.date,
                    data: timetableManager.data,
                    range: model.makeRangeForSheet(activeMonths: timetableManager.data?.getActiveDays() ?? [])
                )
            }
        }
        .onAppear {
            updateTimesheet()
        }
    }
    
    func updateTimesheet() {
        model.makeTimesheet(data: timetableManager.data)
        
        model.timetable = switch model.timesheetBus {
        case .schoolBus(_):
            timetableManager.schoolBusOmiya
        case .schoolBusIwatsuki(_):
            timetableManager.schoolBusIwatsuki
        case .shuttleBus(_):
            timetableManager.shuttleBus
        }
    }
    
    @ViewBuilder
    private func makeTimetable(for bus: BusLineType) -> some View {
        switch bus {
        case .schoolBus, .schoolBusIwatsuki:
            if let timetable = model.getTimetable(for: bus) {
                ScrollView {
                    LazyVStack(
                        alignment: .leading,
                        spacing: 0,
                        pinnedViews: .sectionHeaders
                    ) {
                        Section {
                            if bus.busType == .schoolIwatsuki {
                                switch model.isWeekday {
                                case true:
                                    Text("Detail.SchoolBusIwatsukiWeekday")
                                        .padding()
                                case false:
                                    Text("Detail.SchoolBusIwatsukiSaturday")
                                        .padding()
                                }
                            }
                            
                            SchoolBusGridView(
                                timetable: timetable,
                                showEmpty: bus.busType == .schoolIwatsuki
                            )
                        } header: {
                            Label(bus.localizedTitle, systemImage: bus.symbol)
                                .font(.headline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(.regularMaterial)
                                .clipShape(.rect(cornerRadius: 8))
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                        }
                    }
                }
                .contentMargins(.bottom, 80, for: .scrollContent)
            } else {
                ContentUnavailableView(
                    "Label.NoBuses",
                    systemImage: "bus.fill",
                    description: Text(bus.localizedTitle)
                )
            }
        case .shuttleBus(let bus):
            ShuttleBusTimeTable(
                listType: .grid,
                shuttleType: bus
            )
            .contentMargins(.bottom, 80, for: .scrollContent)
        }
    }
    
    @ViewBuilder
    var horizontalTimetable: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16, pinnedViews: .sectionHeaders) {
                ForEach(model.timesheetBusType.cases, id: \.self) { bus in
                    makeTimetable(for: bus)
                        .frame(width: 420)
                }
            }
            .padding([.top, .trailing])
            .padding(.horizontal, 8)
        }
    }
    
}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    @Previewable @State var model = TimetableViewModel()
    
    TimetableView()
        .environment(timetableManager)
        .environment(model)
}
