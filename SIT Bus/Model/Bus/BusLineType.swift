//
//  BusLineType.swift
//  School Bus
//
//  Created by Yuto on 2024/08/18.
//

import SwiftUI
import AppIntents

protocol BusLine: Codable, Hashable {
    var localizedTitle: LocalizedStringResource { get }
    var localizedShortTitle: LocalizedStringResource { get }
    var symbol: String { get }
    var rawValue: String { get }
}

enum BusLineType: Hashable {
    
    case schoolBus(SchoolBus)
    case schoolBusIwatsuki(SchoolBusIwatsuki)
    case shuttleBus(ShuttleBus)
    
    init?(name: String) {
        switch name {
        case "CampusToOmiyaStation":
            self = .schoolBus(.campusToStation)
        case "OmiyaStationToCampus":
            self = .schoolBus(.stationToCampus)
        case "OmiyaToToyosu":
            self = .shuttleBus(.toToyosu)
        case "ToyosuToOmiya":
            self = .shuttleBus(.toOmiya)
        case "CampusToIwatsukiStation":
            self = .schoolBusIwatsuki(.campusToStation)
        case "IwatsukiStationToCampus":
            self = .schoolBusIwatsuki(.stationToCampus)
        default:
            return nil
        }
    }
    
    var busType: BusType {
        switch self {
        case .schoolBus:
                .schoolOmiya
        case .schoolBusIwatsuki:
                .schoolIwatsuki
        case .shuttleBus:
                .shuttle
        }
    }
    
    var destinationType: BusTimetable.DestinationType {
        switch self {
        case .schoolBus(let bus):
            switch bus {
            case .stationToCampus:
                    .type1
            case .campusToStation:
                    .type2
            }
        case .schoolBusIwatsuki(let bus):
            switch bus {
            case .stationToCampus:
                    .type1
            case .campusToStation:
                    .type2
            }
        case .shuttleBus(let bus):
            switch bus {
            case .toToyosu:
                    .type1
            case .toOmiya:
                    .type2
            }
        }
    }
    
    enum SchoolBus: String, CaseIterable, BusLine {
        case stationToCampus = "StationToCampus"
        case campusToStation = "CampusToStation"
        
        static let allCases: [BusLineType.SchoolBus] = [
            .stationToCampus, .campusToStation,
        ]
        
        var localizedTitle: LocalizedStringResource {
            switch self {
            case .campusToStation:
                .campusToOmiyaStation
            case .stationToCampus:
                .omiyaStationToCampus
            }
        }
        
        var localizedShortTitle: LocalizedStringResource {
            switch self {
            case .campusToStation:
                .campusToOmiyaStationShort
            case .stationToCampus:
                .omiyaStationToCampusShort
            }
        }
        
        var symbol: String {
            switch self {
            case .campusToStation:
                "tram.fill"
            case .stationToCampus:
                "graduationcap.fill"
            }
        }
        
        static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(
            name: .init("BusType")
        )
        
        static var caseDisplayRepresentations: [SchoolBus : DisplayRepresentation] = [
            .stationToCampus: .init(title: .omiyaStationToCampusShort),
            .campusToStation: .init(title: .campusToOmiyaStationShort),
        ]
    }
    
    enum SchoolBusIwatsuki: String, CaseIterable, BusLine {
        case stationToCampus = "IwatsukiStationToCampus"
        case campusToStation = "CampusToIwatsukiStation"
        
        static let allCases: [BusLineType.SchoolBusIwatsuki] = [
            .stationToCampus, .campusToStation,
        ]
        
        var localizedTitle: LocalizedStringResource {
            switch self {
            case .campusToStation:
                .campusToIwatsukiStation
            case .stationToCampus:
                .iwatsukiStationToCampus
            }
        }
        
        var localizedShortTitle: LocalizedStringResource {
            switch self {
            case .campusToStation:
                .campusToIwatsukiStationShort
            case .stationToCampus:
                .iwatsukiStationToCampusShort
            }
        }
        
        var symbol: String {
            switch self {
            case .campusToStation:
                "tram"
            case .stationToCampus:
                "graduationcap"
            }
        }
    }
    
    enum ShuttleBus: String, CaseIterable, BusLine {
        case toToyosu = "OmiyaToToyosu"
        case toOmiya = "ToyosuToOmiya"
        
        static let allCases: [BusLineType.ShuttleBus] = [
            .toToyosu, .toOmiya
        ]
        
        var localizedTitle: LocalizedStringResource {
            switch self {
            case .toToyosu:
                .omiyaToToyosu
            case .toOmiya:
                .toyosuToOmiya
            }
        }
        
        var localizedShortTitle: LocalizedStringResource {
            switch self {
                case .toToyosu:
                    .omiyaToToyosuShort
                case .toOmiya:
                    .toyosuToOmiyaShort
            }
        }
        
        var symbol: String {
            switch self {
            case .toToyosu:
                "point.topleft.down.to.point.bottomright.filled.curvepath"
            case .toOmiya:
                "point.topleft.filled.down.to.point.bottomright.curvepath"
            }
        }
    }
    
    var localizedTitle: LocalizedStringResource {
        switch self {
        case .schoolBus(let schoolBus):
            schoolBus.localizedTitle
        case .shuttleBus(let shuttleBus):
            shuttleBus.localizedTitle
        case .schoolBusIwatsuki(let schoolBus):
            schoolBus.localizedTitle
        }
    }
    
    var localizedShortTitle: LocalizedStringResource {
        switch self {
        case .schoolBus(let schoolBus):
            schoolBus.localizedShortTitle
        case .shuttleBus(let shuttleBus):
            shuttleBus.localizedShortTitle
        case .schoolBusIwatsuki(let schoolBus):
            schoolBus.localizedShortTitle
        }
    }
    
    var rawValue: String {
        switch self {
        case .schoolBus(let bus):
            bus.rawValue
        case .schoolBusIwatsuki(let bus):
            bus.rawValue
        case .shuttleBus(let bus):
            bus.rawValue
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
