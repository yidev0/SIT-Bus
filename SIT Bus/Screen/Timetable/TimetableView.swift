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
                    TimetableWheelchairButton()
                }
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

private struct TimetableWheelchairButton: View {
    
    @State var showPopover: Bool = false
    @ScaledMetric var fontSize: CGFloat = 22
    @ScaledMetric(wrappedValue: 5, relativeTo: .largeTitle)
    var rowEstimate
    
    var body: some View {
        Button {
            showPopover = true
        } label: {
            Image(systemName: "wheelchair")
        }
        .accessibilityLabel("Label.Accessiblity.WheelchairOnBus")
        .sheet(isPresented: $showPopover) {
            NavigationStack {
                Form {
                    Text("Detail.BusWheelchairInfo")
                    
                    Section {
//                        AsyncImage(url: URL(string: "https://www.shibaura-it.ac.jp/assets/6D7A9300.jpg")!) { phase in
//                            if let image = phase.image {
//                                image
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                            } else {
//                                ProgressView()
//                                    .progressViewStyle(.circular)
//                            }
//                        }
//                        .listRowInsets(.init())
                    }
                }
                .toolbar {
                    Button(action: {}) {
                        Text("Label.Done")
                    }
                }
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
