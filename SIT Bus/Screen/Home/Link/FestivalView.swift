//
//  HomeFestivalView.swift
//  SIT Bus
//
//  Created by Yuto on 2025/05/12.
//

import SwiftUI
import WebUI

struct HomeFestivalView: View {
    var body: some View {
        WebView(request: .festivalRequest)
            .toolbarVisibility(.hidden, for: .tabBar)
            .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    HomeFestivalView()
}
