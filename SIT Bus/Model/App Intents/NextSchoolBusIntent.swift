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
    
    @Parameter(title: "Label.BusType")
    var busType: IntentBusLineType
    
    @Parameter(title: "Label.Date", default: .now)
    var date: Date
    
    static var parameterSummary: some ParameterSummary {
        Summary("NextSchoolBusFrom\(\.$date).Summary", table: "Intents") {
            \.$busType
        }
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let schoolBusData = await BusDataFetcher().fetchLocalData()
        switch schoolBusData {
        case .success(let success):
            let timetable = success.toBusTimetable()
            if let nextBus = timetable.getNext(from: date, type: busType.toBusLineType().destinationType) {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = .autoupdatingCurrent
                dateFormatter.timeStyle = .medium
                dateFormatter.dateStyle = .medium
                return .result(value: dateFormatter.string(from: nextBus))
            } else {
                return .result(value: "Label.BusServiceEnded".localize)
            }
        case .failure(let failure):
            throw failure
        }
    }
    
}
