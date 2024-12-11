//
//  SITBusActivityAttributes.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/10.
//

import ActivityKit
import WidgetKit

struct SITBusActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var nextBusTime: Date?
        var remainingMinutes: Int
    }
    
    // Fixed non-changing properties about your activity go here!
    var busType: BusLineType.SchoolBus
}
