//
//  Item.swift
//  SIT Bus Clip
//
//  Created by Yuto on 2026/08/01.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
