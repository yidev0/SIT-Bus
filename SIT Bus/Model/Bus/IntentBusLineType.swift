//
//  IntentBusLineType.swift
//  SIT Bus
//
//  Created by Yuto on 2025/08/31.
//

import AppIntents

enum IntentBusLineType: String, CaseIterable, AppEnum {
    case schoolStationToCampus
    case schoolCampusToStation
    case iwatsukiStationToCampus
    case iwatsukiCampusToStation
    case shuttleToToyosu
    case shuttleToOmiya

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        .init(name: "Timetable")
    }

    static var caseDisplayRepresentations: [IntentBusLineType : DisplayRepresentation] {
        [
            .schoolStationToCampus: .init(title: .init("OmiyaStationToCampus")),
            .schoolCampusToStation: .init(title: .init("CampusToOmiyaStation")),
            .iwatsukiStationToCampus: .init(title: .init("IwatsukiStationToCampus")),
            .iwatsukiCampusToStation: .init(title: .init("CampusToIwatsukiStation")),
            .shuttleToToyosu: .init(title: .init("OmiyaToToyosu")),
            .shuttleToOmiya: .init(title: .init("ToyosuToOmiya")),
        ]
    }

    func toBusLineType() -> BusLineType {
        switch self {
        case .schoolStationToCampus:
            return .schoolBus(.stationToCampus)
        case .schoolCampusToStation:
            return .schoolBus(.campusToStation)
        case .iwatsukiStationToCampus:
            return .schoolBusIwatsuki(.stationToCampus)
        case .iwatsukiCampusToStation:
            return .schoolBusIwatsuki(.campusToStation)
        case .shuttleToToyosu:
            return .shuttleBus(.toToyosu)
        case .shuttleToOmiya:
            return .shuttleBus(.toOmiya)
        }
    }
}
