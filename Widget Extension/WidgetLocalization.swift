//
//  WidgetLocalization.swift
//  Widget Extension
//
//  Created by Yuto on 2026/07/04.
//

import SwiftUI

extension LocalizedStringResource {
    static let widgetNextBus = LocalizedStringResource("NextBus", table: "Widget")
    static let widgetTimelyOperation = LocalizedStringResource("TimelyOperation", table: "Widget")
    static let widgetSITBusWidget = LocalizedStringResource("SITBusWidget", table: "Widget")
    static let widgetSITBusWidgetDetail = LocalizedStringResource("SITBusWidget.detail", table: "Widget")

    static func widgetMinutesShort(_ minutes: Int) -> LocalizedStringResource {
        LocalizedStringResource("Minutes.short\(minutes)", table: "Widget")
    }

    static func widgetTimelyOperation(_ start: Text, _ end: Text) -> LocalizedStringResource {
        LocalizedStringResource("TimelyOperation(\(start),\(end))", table: "Widget")
    }
}
