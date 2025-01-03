//
//  TimetableView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import SwiftUI

struct TimetableView: View {
    
    @State private var model = TimetableViewModel()
    @Environment(TimetableManager.self) private var timetableManager
    
    var body: some View {
        @Bindable var model = model
        
        NavigationStack {
            ZStack {
                switch model.timesheetBus {
                case .schoolBus:
                    if let timetable = model.timetable {
                        ScrollView {
                            SchoolBusGridView(timetable: timetable)
                        }
                        .contentMargins(.bottom, 80, for: .scrollContent)
                    } else {
                        ContentUnavailableView(
                            "Label.NoBuses",
                            systemImage: "exclamationmark.triangle.fill"
                        )
                    }
                case .shuttleBus(let bus):
                    ShuttleBusTimeTable(
                        listType: .grid,
                        shuttleType: bus
                    )
                    .contentMargins(.bottom, 80, for: .scrollContent)
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
                if model.timesheetBus.isSchoolBus {
                    Button {
                        model.showInfoSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel("Label.Accessiblity.Information")
                }
            }
            .sheet(isPresented: $model.showInfoSheet) {
                TimetableInformationView()
            }
        }
        .onAppear {
            updateTimesheet()
        }
    }
    
    func updateTimesheet() {
        model.makeTimesheet(data: timetableManager.data)
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
