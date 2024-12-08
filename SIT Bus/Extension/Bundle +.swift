//
//  Bundle +.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/04.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
    
    var appName: String? {
        infoDictionary?["CFBundleName"] as? String
    }
}
