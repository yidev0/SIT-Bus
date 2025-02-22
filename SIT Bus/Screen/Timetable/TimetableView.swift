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
                    case .schoolOmiya, .schoolIwatsuki:
                        if model.isActiveDate {
                            horizontalTimetable
                        } else {
                            ContentUnavailableView(
                                "Label.NoBuses",
                                systemImage: "exclamationmark.triangle.fill"
                            )
                        }
                    case .shuttle:
                        horizontalTimetable
                    }
                } else {
                    makeTimetable(for: model.timesheetBus)
                    
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            if model.timesheetBus.busType == .schoolOmiya {
                                DatePickerButton(
                                    selectedDate: $model.timesheetDate,
                                    showPicker: $model.showTimesheetDatePicker,
                                    activeDates: timetableManager.data?.getActiveDays() ?? []
                                )
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
            //            .refreshable {
            //                model.timesheetDate = Date()
            //            }
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
        VStack(alignment: .leading, spacing: 0) {
            Label(bus.localizedTitle, systemImage: bus.symbol)
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            switch bus {
            case .schoolBus, .schoolBusIwatsuki:
                if let timetable = model.getTimetable(for: bus) {
                    ScrollView {
                        SchoolBusGridView(timetable: timetable)
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
