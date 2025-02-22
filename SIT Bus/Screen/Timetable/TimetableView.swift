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
                    if model.timetable != nil {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 16, pinnedViews: .sectionHeaders) {
                                ForEach(BusLineType.SchoolBus.allCases, id: \.self) { bus in
                                    makeTimetable(for: .schoolBus(bus))
                                        .frame(width: 420)
                                }
                            }
                            .padding([.top, .trailing])
                            .padding(.horizontal, 8)
                        }
                    } else {
                        ContentUnavailableView(
                            "Label.NoBuses",
                            systemImage: "exclamationmark.triangle.fill"
                        )
                    }
                } else {
                    makeTimetable(for: model.timesheetBus)
                }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        if model.timesheetBus.isSchoolBus {
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
    func makeTimetable(for bus: BusLineType) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if horizontalSizeClass == .regular {
                Label(bus.localizedTitle, systemImage: bus.symbol)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            
            switch bus {
            case .schoolBus:
                if let timetable = model.timetable {
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
