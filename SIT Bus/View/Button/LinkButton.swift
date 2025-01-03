//
//  LinkButton.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/22.
//

import SwiftUI
import SafariServices

struct LinkButton<Label: View>: View {
    
    @AppStorage(UserDefaultsKeys.openLinkInApp)
    var openInApp: Bool = true
    
    var url: URL
    var label: Label
    
    init(
        _ urlString: String,
        @ViewBuilder label: () -> Label
    ) {
        self.url = URL(string: urlString)!
        self.label = label()
    }
    
    init(
        _ url: URL,
        @ViewBuilder label: () -> Label
    ) {
        self.url = url
        self.label = label()
    }
    
    var body: some View {
        switch openInApp {
        case true:
            Button {
                let safariVC = SFSafariViewController(url: url)
                UIApplication.shared.currentUIWindow()?.rootViewController?.present(safariVC, animated: true)
            } label: {
                label
                    .makeListLink()
            }
        case false:
            Link(destination: url) {
                label
                    .makeListLink()
            }
        }
    }
}

#Preview {
    LinkButton(.init(string: "https://google.com")!) {
        Text(verbatim: "Open Link")
    }
}
