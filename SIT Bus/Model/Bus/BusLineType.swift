//
//  BusLineType.swift
//  School Bus
//
//  Created by Yuto on 2024/08/18.
//

import SwiftUI
import AppIntents

protocol BusType: Codable {
    var localizedTitle: LocalizedStringKey { get }
    var localizedShortTitle: LocalizedStringKey { get }
    var symbol: String { get }
}

enum BusLineType: CaseIterable, Hashable {
    static var allCases: [BusLineType] = [
        .schoolBus(.stationToCampus),
        .schoolBus(.campusToStation),
        .shuttleBus(.toOmiya),
        .shuttleBus(.toToyosu),
    ]
    
    case schoolBus(SchoolBus)
    case shuttleBus(ShuttleBus)
    
    var isSchoolBus: Bool {
        switch self {
        case .schoolBus:
            true
        case .shuttleBus:
            false
        }
    }
    
    var isShuttleBus: Bool {
        switch self {
        case .schoolBus:
            false
        case .shuttleBus:
            true
        }
    }
    
    enum SchoolBus: String, CaseIterable, BusType, AppEnum {
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
    
    enum ShuttleBus: String, CaseIterable, BusType {
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
        }
    }
    
    var localizedShortTitle: LocalizedStringKey {
        switch self {
        case .schoolBus(let schoolBus):
            schoolBus.localizedShortTitle
        case .shuttleBus(let shuttleBus):
            shuttleBus.localizedShortTitle
        }
    }
    
    var symbol: String {
        switch self {
        case .schoolBus(let schoolBus):
            schoolBus.symbol
        case .shuttleBus(let shuttleBus):
            shuttleBus.symbol
        }
    }
}
