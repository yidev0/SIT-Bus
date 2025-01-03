//
//  SettingsCreditsView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/21.
//

import SwiftUI

struct SettingsCreditsView: View {
    var body: some View {
        List {
            Section("OSS") {
                LinkButton("https://github.com/cybozu/WebUI/blob/main/LICENSE") {
                    Text(verbatim: "cybozu/WebUI")
                }
                
                LinkButton("https://github.com/jeremieb/social-symbols/blob/main/LICENSE") {
                    Text(verbatim: "jeremieb/social-symbols")
                }
            }
            
            Section("Label.Localization") {
                
            }
        }
    }
}

#Preview {
    SettingsCreditsView()
}
