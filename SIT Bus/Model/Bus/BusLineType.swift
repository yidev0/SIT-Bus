//
//  BusLineType.swift
//  School Bus
//
//  Created by Yuto on 2024/08/18.
//

import SwiftUI
import AppIntents

protocol BusLine: Codable, Hashable {
    var localizedTitle: LocalizedStringKey { get }
    var localizedShortTitle: LocalizedStringKey { get }
    var symbol: String { get }
    var rawValue: String { get }
}

enum BusLineType: CaseIterable, Hashable {
    static var allCases: [BusLineType] = [
        .schoolBus(.stationToCampus),
        .schoolBus(.campusToStation),
        .shuttleBus(.toOmiya),
        .shuttleBus(.toToyosu),
    ]
    
    case schoolBus(SchoolBus)
    case schoolBusIwatsuki(SchoolBusIwatsuki)
    case shuttleBus(ShuttleBus)
    
    var isSchoolBus: Bool {
        switch self {
        case .schoolBus, .schoolBusIwatsuki:
            true
        case .shuttleBus:
            false
        }
    }
    
    var isShuttleBus: Bool {
        switch self {
        case .schoolBus, .schoolBusIwatsuki:
            false
        case .shuttleBus:
            true
        }
    }
    
    enum SchoolBus: String, CaseIterable, BusLine, AppEnum {
        case stationToCampus = "StationToCampus"
        case campusToStation = "CampusToStation"
        
        static var allCases: [BusLineType.SchoolBus] = [
            .stationToCampus, .campusToStation,
        ]
        
        var localizedTitle: LocalizedStringKey {
            switch self {
            case .campusToStation:
                "Label.CampusToOmiyaStation"
            case .stationToCampus:
                "Label.OmiyaStationToCampus"
            }
        }
        
        var localizedShortTitle: LocalizedStringKey {
            switch self {
            case .campusToStation:
                "Label.Short.CampusToOmiyaStation"
            case .stationToCampus:
                "Label.Short.OmiyaStationToCampus"
            }
        }
        
        var symbol: String {
            switch self {
            case .campusToStation:
                "graduationcap.fill"
            case .stationToCampus:
                "tram.fill"
            }
        }
        
        static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(
            name: .init("Label.BusType")
        )
        
        static var caseDisplayRepresentations: [SchoolBus : DisplayRepresentation] = [
            .stationToCampus: .init(title: .init("Label.Short.OmiyaStationToCampus")),
            .campusToStation: .init(title: .init("Label.Short.CampusToOmiyaStation")),
        ]
    }
    
    enum SchoolBusIwatsuki: String, CaseIterable, BusLine {
        case stationToCampus = "IwatsukiStationToCampus"
        case campusToStation = "CampusToIwatsukiStation"
        
        static var allCases: [BusLineType.SchoolBus] = [
            .stationToCampus, .campusToStation,
        ]
        
        var localizedTitle: LocalizedStringKey {
            switch self {
            case .campusToStation:
                "Label.CampusToIwatsukiStation"
            case .stationToCampus:
                "Label.IwatsukiStationToCampus"
            }
        }
        
        var localizedShortTitle: LocalizedStringKey {
            switch self {
            case .campusToStation:
                "Label.Short.CampusToIwatsukiStation"
            case .stationToCampus:
                "Label.Short.IwatsukiStationToCampus"
            }
        }
        
        var symbol: String {
            switch self {
            case .campusToStation:
                "graduationcap"
            case .stationToCampus:
                "tram"
            }
        }
    }
    
    enum ShuttleBus: String, CaseIterable, BusLine {
        case toToyosu = "OmiyaToToyosu"
        case toOmiya = "ToyosuToOmiya"
        
        static var allCases: [BusLineType.ShuttleBus] = [
            .toToyosu, .toOmiya
        ]
        
        var localizedTitle: LocalizedStringKey {
            switch self {
            case .toToyosu:
                "Label.OmiyaToToyosu"
            case .toOmiya:
                "Label.ToyosuToOmiya"
            }
        }
        
        var localizedShortTitle: LocalizedStringKey {
            switch self {
                case .toToyosu:
                    "Label.Short.OmiyaToToyosu"
                case .toOmiya:
                    "Label.Short.ToyosuToOmiya"
            }
        }
        
        var symbol: String {
            switch self {
            case .toToyosu:
                "app.connected.to.app.below.fill"
            case .toOmiya:
                "app.connected.to.app.below.fill"
            }
        }
    }
    
    var localizedTitle: LocalizedStringKey {
        switch self {
        case .schoolBus(let schoolBus):
            schoolBus.localizedTitle
        case .shuttleBus(let shuttleBus):
            shuttleBus.localizedTitle
        case .schoolBusIwatsuki(let schoolBus):
            schoolBus.localizedTitle
        }
    }
    
    var localizedShortTitle: LocalizedStringKey {
        switch self {
        case .schoolBus(let schoolBus):
            schoolBus.localizedShortTitle
        case .shuttleBus(let shuttleBus):
            shuttleBus.localizedShortTitle
        case .schoolBusIwatsuki(let schoolBus):
            schoolBus.localizedShortTitle
        }
    }
    
    var symbol: String {
        switch self {
        case .schoolBus(let schoolBus):
            schoolBus.symbol
        case .shuttleBus(let shuttleBus):
            shuttleBus.symbol
        case .schoolBusIwatsuki(let schoolBus):
            schoolBus.symbol
        }
    }
}
