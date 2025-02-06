//
//  UserDefaultsKeys.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/22.
//

struct UserDefaultsKeys {
    /// Wether to open url in-app or default browser
    static let openLinkInApp = "OpenLinkInApp"
    /// Save Coop service file locally
    static let saveCoopSchedule = "SaveCoopSchedule"
    /// Hide Google Calendar for privacy
    static let hideGoogleCalendar = "HideGoogleCalendar"
    /// Last saved date interval since 1970, since bus data is saved
    static let lastUpdateDate = "LastUpdateDate"
    /// If the user has reviewed the app in v1
    static let hasReviewedApp = "HasReviewedApp.V1"
    
    static let debugDate = "DebugDate"
}
