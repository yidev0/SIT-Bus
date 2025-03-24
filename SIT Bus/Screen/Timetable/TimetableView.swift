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
                if horizontalSizeClass == .regular {
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
                } else {
                    if model.isActiveDate || model.timesheetBusType != .schoolOmiya {
                        makeTimetable(for: model.timesheetBus)
                    } else {
                        ContentUnavailableView(
                            "Label.NoBuses",
                            systemImage: "exclamationmark.triangle.fill"
                        )
                    }
                    
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            switch model.timesheetBusType {
                            case .schoolOmiya:
                                DatePickerButton(
                                    selectedDate: $model.timesheetDate,
                                    showPicker: $model.showTimesheetDatePicker,
                                    showFullPicker: $model.showFullTimesheetDatePicker,
                                    activeDates: timetableManager.data?.getActiveDays() ?? []
                                )
                            case .schoolIwatsuki:
                                Menu {
                                    Picker(selection: $model.isWeekday) {
                                        Text("Label.Weekday")
                                            .tag(true)
                                        Text("Label.Saturday")
                                            .tag(false)
                                    } label: {
                                        Text("Label.ScheduleType")
                                    }
                                } label: {
                                    switch model.isWeekday {
                                    case true:
                                        Text("Label.Weekday")
                                    case false:
                                        Text("Label.Saturday")
                                    }
                                }
                            case .shuttle:
                                EmptyView()
                            }
                            
                            BusPickerView(
                                selectedBus: $model.timesheetBus
                            )
                        }
                        .padding(.bottom, 16)
                        .buttonStyle(.filter)
                    }
                    .animation(.default, value: model.timesheetBus)
                }
            }
            .navigationTitle("Label.Timetable")
            .navigationBarTitleDisplayMode(UIDevice.current.userInterfaceIdiom == .pad ? .inline : .automatic)
            .background(Color(.systemGroupedBackground))
            .onChange(of: model.timesheetBus) { _, _ in
                updateTimesheet()
            }
            .onChange(of: model.timesheetDate) { _, _ in
                updateTimesheet()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        model.showInfoSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel("Label.Accessiblity.Information")
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
                    
                    if model.timesheetBusType != .shuttle  {
                        ToolbarItem(placement: .topBarLeading) {
                            DatePickerButton(
                                selectedDate: $model.timesheetDate,
                                showPicker: $model.showTimesheetDatePicker,
                                showFullPicker: $model.showFullTimesheetDatePicker,
                                activeDates: timetableManager.data?.getActiveDays() ?? []
                            )
                            .fontWeight(.semibold)
                        }
                    }
                }
            }
            .sheet(isPresented: $model.showInfoSheet) {
                TimetableInformationView()
            }
            .fullScreenCover(isPresented: $model.showFullTimesheetDatePicker) {
                TimetableFullDatePickerView(
                    date: $model.timesheetDate,
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
                            SchoolBusGridView(timetable: timetable)
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
    @Previewable @State var model = TimetableViewModel(
        date: .createDate(year: 2024, month: 9, day: 30)!
    )
    
    TimetableView()
        .environment(timetableManager)
        .environment(model)
}
