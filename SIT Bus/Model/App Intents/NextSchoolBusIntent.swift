//
//  NextSchoolBusIntent.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//

import AppIntents

struct NextSchoolBusIntent: AppIntent {
    
    static var title: LocalizedStringResource = .init("GetNextBus.Title", table: "Shortcuts")
    
    @Parameter(title: "")
    var busType: BusLineType.SchoolBus
    
    @Parameter(default: .now)
    var date: Date
    
    static var parameterSummary: some ParameterSummary {
        Summary("NextSchoolBus.Summary", table: "Shortcuts") {
            \.$date
            \.$busType
        }
    }
    
    func perform() async throws -> some IntentResult {
        .result()
    }
    
}
