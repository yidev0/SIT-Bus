//
//  ShuttleBusTimeTable.swift
//  School Bus
//
//  Created by Yuto on 2024/09/23.
//

import SwiftUI

struct ShuttleBusTimeTable: View {
    
    let listType: ListType
    let shuttleType: BusLineType.ShuttleBus
    
    @State var busData = [Date: [Date]]()
    @ScaledMetric var headerSize = 17
    
    @State var scrollPosition: Date? = .now
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                switch listType {
                case .grid:
                    Section {
                        grid
                    } header: {
                        HStack {
                            Spacer()
                            switch shuttleType {
                            case .toToyosu:
                                Text("Detail.ShuttleToToyosu")
                            case .toOmiya:
                                Text("Detail.ShuttleToOmiya")
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                    }
                case .list:
                    list
                        .onAppear {
                            scrollPosition = getNextBus()
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .padding(.bottom, 60)
        }
        .scrollPosition(id: $scrollPosition)
        .onAppear {
            loadData()
        }
    }
    
    var grid: some View {
        ForEach(Array(busData.keys.sorted()), id: \.keyYearMonth) { key in
            if showHeader(date: key) {
                makeHeader(for: key)
                    .padding(.top, 8)
            }
            
            HStack {
                TimetableHeader(
                    text: key.getShortMonthText(),
                    radius: 8
                )
                .frame(width: 64)
                
                LazyVGrid(
                    columns: [.init(
                        .adaptive(minimum: 64, maximum: 120),
                        spacing: 4
                    )],
                    spacing: 4
                ) {
                    ForEach(busData[key] ?? [], id: \.self) { date in
                        ShuttleBusTimeGridCell(
                            date: date,
                            shuttleType: shuttleType
                        )
                    }
                }
                .padding(4)
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color(.secondarySystemGroupedBackground))
            }
        }
    }
    
    var list: some View {
        ForEach(Array(busData.keys.sorted()), id: \.keyYearMonth) { key in
            Section {
                ForEach(busData[key] ?? [], id: \.self) { date in
                    ShuttleBusTimeListCell(
                        date: date,
                        shuttleType: shuttleType
                    )
                    .onAppear {
                        print("cell", date)
                    }
                }
            } header: {
                HStack {
                    if showHeader(date: key) {
                        Text(key, format: .dateTime.year().month())
                            .font(.headline)
                    } else {
                        Text(key, format: .dateTime.month())
                            .font(.headline)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 4)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding(.top, 4)
            }
        }
    }
    
    private func makeHeader(for date: Date) -> some View {
        HStack {
            Text(date, format: .dateTime.year())
                .fontWeight(.bold)
            Spacer()
        }
    }
    
    private func loadData() {
        let shuttleBusData = ShuttleBusData()
        let months = shuttleBusData.getMonths()
        
        var data = [Date: [Date]]()
        for month in months {
            let dates = shuttleBusData.getTimesFor(
                year: month.get(component: .year),
                month: month.get(component: .month)
            )
            data[month] = dates
        }
        
        busData = data
    }
    
    private func getNextBus() -> Date? {
        let shuttleBusData = ShuttleBusData()
        print("scroll", shuttleBusData.getNextDate(for: shuttleType))
        return shuttleBusData.getNextDate(for: shuttleType)
    }
    
    private func showHeader(date: Date) -> Bool {
        (date.get(component: .year) == 2025
         && date.get(component: .month) == 1)
        || busData.keys.sorted().first == date
    }
}

#Preview {
    ShuttleBusTimeTable(
        listType: .grid,
        shuttleType: .toOmiya
    )
}

#Preview {
    ShuttleBusTimeTable(
        listType: .list,
        shuttleType: .toOmiya
    )
}
