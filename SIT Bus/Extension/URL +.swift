//
//  URL +.swift
//  SIT Bus
//
//  Created by Yuto on 2025/10/04.
//

import Foundation

extension URL {
    static let appStore = URL(string: "https://apps.apple.com/app/id6736679708")!
    static let schoolBusOmiya = URL(string: "http://bus.shibaura-it.ac.jp/db/bus_data.json")!
    static let schoolBusIwatsuki = URL(string: "http://bus.shibaura-it.ac.jp/iwatsuki/db/bus_data.json")!
    static let shuttleBus = URL(string: String(localized: .urlShuttleBus))!
}
