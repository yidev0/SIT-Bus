//
//  AppSettings.swift
//  SIT Bus
//
//  Created by Codex on 2026/03/02.
//

import Foundation

final class AppSettings {
    private let sharedDefaults: UserDefaults
    private let standardDefaults: UserDefaults
    
    init(
        sharedDefaults: UserDefaults = .shared,
        standardDefaults: UserDefaults = .standard
    ) {
        self.sharedDefaults = sharedDefaults
        self.standardDefaults = standardDefaults
    }
    
    var lastUpdateDate: Date {
        get {
            Date(timeIntervalSince1970: sharedDefaults.double(forKey: UserDefaultsKeys.lastUpdateDate))
        }
        set {
            sharedDefaults.set(newValue.timeIntervalSince1970, forKey: UserDefaultsKeys.lastUpdateDate)
        }
    }
    
    var hasExistingLastUpdateDate: Bool {
        sharedDefaults.value(forKey: UserDefaultsKeys.lastUpdateDate) != nil
    }
    
    var hasReviewedAppV1: Bool {
        get {
            standardDefaults.bool(forKey: UserDefaultsKeys.hasReviewedApp)
        }
        set {
            standardDefaults.set(newValue, forKey: UserDefaultsKeys.hasReviewedApp)
        }
    }
    
    var timetableBus: String? {
        get {
            standardDefaults.string(forKey: UserDefaultsKeys.timetableBus)
        }
        set {
            standardDefaults.set(newValue, forKey: UserDefaultsKeys.timetableBus)
        }
    }
    
    var timetableBusType: String? {
        get {
            standardDefaults.string(forKey: UserDefaultsKeys.timetableBusType)
        }
        set {
            standardDefaults.set(newValue, forKey: UserDefaultsKeys.timetableBusType)
        }
    }
    
    var shownWelcome2: Bool {
        get {
            standardDefaults.bool(forKey: UserDefaultsKeys.shownWelcome2)
        }
        set {
            standardDefaults.set(newValue, forKey: UserDefaultsKeys.shownWelcome2)
        }
    }
}
