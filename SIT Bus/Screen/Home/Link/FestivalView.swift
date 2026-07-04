//
//  HomeFestivalView.swift
//  SIT Bus
//
//  Created by Yuto on 2025/05/12.
//

import SwiftUI
import WebUI

struct HomeFestivalView: View {
    
    private var request: URLRequest
    
    init() {
        let month = Date.now.get(.month)
        self.request = switch month {
        case 6...12:
                .shibauraFestivalRequest
        default:
                .omiyaFestivalRequest
        }
    }
    
    var body: some View {
        WebView(request: request)
            .toolbarVisibility(.hidden, for: .tabBar)
            .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    HomeFestivalView()
}
