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
        .init(name: "Label.Timetable")
    }

    static var caseDisplayRepresentations: [IntentBusLineType : DisplayRepresentation] {
        [
            .schoolStationToCampus: .init(title: .init("Label.OmiyaStationToCampus")),
            .schoolCampusToStation: .init(title: .init("Label.CampusToOmiyaStation")),
            .iwatsukiStationToCampus: .init(title: .init("Label.IwatsukiStationToCampus")),
            .iwatsukiCampusToStation: .init(title: .init("Label.CampusToIwatsukiStation")),
            .shuttleToToyosu: .init(title: .init("Label.OmiyaToToyosu")),
            .shuttleToOmiya: .init(title: .init("Label.ToyosuToOmiya")),
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
