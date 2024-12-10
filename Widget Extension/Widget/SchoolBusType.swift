//
//  SchoolBusType.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/10.
//

import WidgetKit
import AppIntents

enum SchoolBusType: String, AppEnum {
    case campusToOmiya = "CampusToOmiya"
    case omiyaToCampus = "OmiyaToCampus"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(
        name: .init("Label.BusType", table: "Widget")
    )
    
    static var caseDisplayRepresentations: [SchoolBusType : DisplayRepresentation] = [
        .campusToOmiya: .init(title: .init("Label.Short.CampusToOmiyaStation")),
        .omiyaToCampus: .init(title: .init("Label.Short.OmiyaStationToCampus")),
    ]
}
