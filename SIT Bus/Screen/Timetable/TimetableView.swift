//
//  TimetableView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import SwiftUI

struct TimetableView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Namespace var namespace
    
    @State private var model = TimetableViewModel()
    @Environment(TimetableManager.self) private var timetableManager
    
    var body: some View {
        @Bindable var model = model
        
        NavigationStack {
            ZStack {
                switch horizontalSizeClass {
                case .regular:
                    switch model.timesheetBusType {
                    case .schoolOmiya, .schoolIwatsuki:
                        if model.isActive {
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
                            if #available(iOS 26, *) {
                                Button {
                                    model.showDatePicker = true
                                } label: {
                                    Text(model.date, format: .dateTime.day().month().weekday())
                                }
                                .matchedTransitionSource(id: "DatePicker", in: namespace)
                            } else {
                                DatePickerButton(
                                    selectedDate: $model.date,
                                    activeDates: model.timetable?.getActiveDates() ?? []
                                )
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
                        model.showInfoSheet = true
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
                        case .schoolOmiya, .schoolIwatsuki:
                            DatePickerButton(
                                selectedDate: $model.date,
                                activeDates: model.timetable?.getActiveDates() ?? []
                            )
                        case .shuttle:
                            EmptyView()
                        }
                    }
                }
            }
            .sheet(isPresented: $model.showInfoSheet) {
                TimetableInformationView()
            }
            .sheet(isPresented: $model.showDatePicker) {
                TimetableCalendarView(
                    date: $model.date,
                    activeDates: model.timetable?.getActiveDates() ?? []
                )
                .ignoresSafeArea()
                .padding([.horizontal, .top])
                .presentationDetents([.large, .medium])
                .presentationCompactAdaptation(.sheet)
                .navigationTransition(.zoom(sourceID: "DatePicker", in: namespace))
                .presentationBackground(.regularMaterial)
            }
        }
        .onAppear {
            updateTimesheet()
        }
    }
    
    func updateTimesheet() {
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
    var horizontalTimetable: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16, pinnedViews: .sectionHeaders) {
                ForEach(model.timesheetBusType.cases, id: \.self) { bus in
                    TimetableContentView(
                        table: model.timetable?.getTable(for: model.date),
                        for: bus,
                        date: model.date
                    )
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
