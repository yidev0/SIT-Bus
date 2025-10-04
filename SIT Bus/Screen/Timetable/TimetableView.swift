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
                    if model.isActive {
                        horizontalTimetable
                    } else {
                        ContentUnavailableView(
                            "Label.NoBuses",
                            systemImage: "exclamationmark.triangle.fill"
                        )
                    }
                default:
                    TimetableContentView(
                        table: model.timetable?.getTable(for: model.date),
                        for: model.busLineType,
                        date: model.date
                    )
                }
            }
            .safeAreaInset(edge: .bottom) {
                switch horizontalSizeClass {
                case .compact:
                    TimetableCompactMenu(namespace: namespace)
                default:
                    EmptyView()
                }
            }
            .navigationTitle("Label.Timetable")
            .toolbarTitleDisplayMode(.automatic)
            .background(Color(.systemGroupedBackground))
            .animation(.default, value: model.busLineType)
            .onChange(of: model.busLineType) { _, newValue in
                updateTimesheet(for: newValue.busType)
            }
            .onChange(of: model.busType) { _, newValue in
                updateTimesheet(for: newValue)
            }
            .onChange(of: model.date) { _, _ in
                if horizontalSizeClass == .regular {
                    updateTimesheet(for: model.busType)
                } else {
                    updateTimesheet(for: model.busLineType.busType)
                }
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
                        Picker(selection: $model.busType) {
                            ForEach(BusType.allCases, id: \.rawValue) { type in
                                Label(type.localizedTitle, systemImage: type.symbol)
                                    .tag(type)
                            }
                        } label: {
                            Text(model.busType.localizedTitle)
                        }
                    }
                    
                    if #available(iOS 26.0, *) {
                        ToolbarSpacer(placement: .topBarLeading)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        DatePickerButton(
                            selectedDate: $model.date,
                            activeDates: model.timetable?.getActiveDates() ?? []
                        )
                    }
                }
            }
            .sheet(isPresented: $model.showInfoSheet) {
                TimetableInformationView()
                    .navigationTransition(.zoom(sourceID: "Information", in: namespace))
            }
            .sheet(isPresented: $model.showDatePicker) {
                TimetableCalendarSheet()
                    .navigationTransition(.zoom(sourceID: "DatePicker", in: namespace))
            }
        }
        .environment(model)
        .onAppear {
            if horizontalSizeClass == .regular {
                updateTimesheet(for: model.busType)
            } else {
                updateTimesheet(for: model.busLineType.busType)
            }
        }
    }
    
    func updateTimesheet(for type: BusType) {
        model.timetable = switch type {
        case .schoolOmiya:
            timetableManager.schoolBusOmiya
        case .schoolIwatsuki:
            timetableManager.schoolBusIwatsuki
        case .shuttle:
            timetableManager.shuttleBus
        }
    }
    
    @ViewBuilder
    var horizontalTimetable: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16, pinnedViews: .sectionHeaders) {
                ForEach(model.busType.cases, id: \.self) { bus in
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

private struct TimetableCalendarSheet: View {

    @Environment(TimetableViewModel.self)
    var model
    
    @State
    var detent: PresentationDetent = .medium
    
    var body: some View {
        @Bindable var model = model

        List {
            TimetableCalendarView(
                date: $model.date,
                activeDates: model.timetable?.getActiveDates() ?? []
            )
            
            Section {
                if let name = model.timetable?.getCalendar(for: model.date)?.tableName {
                    Text(verbatim: name)
                }
                
                if let comment = model.timetable?.getCalendar(for: model.date)?.comment {
                    Text(verbatim: comment)
                }
            }
        }
        .listSectionSpacing(.compact)
        .presentationDetents([.large, .medium], selection: $detent)
        .presentationCompactAdaptation(.sheet)
        .presentationBackground(.thinMaterial)
    }
}

#Preview {
    @Previewable @State var timetableManager = TimetableManager()
    @Previewable @State var model = TimetableViewModel()
    
    TimetableView()
        .environment(timetableManager)
        .environment(model)
}
