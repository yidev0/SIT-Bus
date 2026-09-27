//
//  NextSchoolBusIntent.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//

import AppIntents

struct NextSchoolBusIntent: AppIntent {
    
    static var title: LocalizedStringResource = .init("GetNextBus.Title", table: "Intents")
    static var description: IntentDescription? = .init(.init("GetNextBus.Description", table: "Intents"))
    
    @Parameter(title: LocalizedStringResource("BusType"))
    var busType: IntentBusLineType
    
    @Parameter(title: LocalizedStringResource("Date"), default: .now)
    var date: Date
    
    static var parameterSummary: some ParameterSummary {
        Summary("NextSchoolBusFrom\(\.$date).Summary", table: "Intents") {
            \.$busType
        }
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let line = busType.toBusLineType()
        let timetable: BusTimetable
        switch line {
        case .schoolBus:
            let data = try await BusRepository().fetchLocal().get()
            timetable = data.toBusTimetable()
        case .schoolBusIwatsuki:
            let data = try await BusRepository(route: .iwatsuki).fetchLocal().get()
            timetable = data.toBusTimetable(source: BusDataFetcher.Route.iwatsuki.url)
        case .shuttleBus:
            timetable = .shuttleBus
        }

        if let nextBus = timetable.getNext(from: date, type: line.destinationType) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .autoupdatingCurrent
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .medium
            return .result(value: dateFormatter.string(from: nextBus))
        } else {
            return .result(value: String(localized: .busServiceEnded))
        }
    }
    
}
