//
//  AppClock.swift
//  SIT Bus
//
//  Created by Codex on 2026/03/02.
//

import Foundation

protocol AppClock {
    var now: Date { get }
}

struct SystemClock: AppClock {
    var now: Date { .now }
}
