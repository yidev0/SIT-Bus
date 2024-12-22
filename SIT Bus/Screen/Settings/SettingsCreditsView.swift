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
                Link(destination: .init(string: "https://github.com/cybozu/WebUI/blob/main/LICENSE")!) {
                    Text(verbatim: "cybozu/WebUI")
                }
                .makeListLink()
                
                Link(destination: .init(string: "https://github.com/jeremieb/social-symbols/blob/main/LICENSE")!) {
                    Text(verbatim: "jeremieb/social-symbols")
                }
                .makeListLink()
            }
            
            Section("Label.Localization") {
                
            }
        }
    }
}

#Preview {
    SettingsCreditsView()
}
