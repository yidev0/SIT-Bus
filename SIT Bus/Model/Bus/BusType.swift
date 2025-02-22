//
//  BusType.swift
//  SIT Bus
//
//  Created by Yuto on 2025/02/22.
//

import SwiftUI

enum BusType: String, CaseIterable {
    case schoolOmiya
    case schoolIwatsuki
    case shuttle
    
    var localizedTitle: LocalizedStringKey {
        switch self {
        case .schoolOmiya:
            "Label.SchoolBusOmiya"
        case .schoolIwatsuki:
            "Label.SchoolBusIwatsuki"
        case .shuttle:
            "Label.ShuttleBus"
        }
    }
}
