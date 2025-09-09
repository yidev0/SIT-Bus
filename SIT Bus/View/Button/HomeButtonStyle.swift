//
//  HomeButtonStyle.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/06.
//

import SwiftUI

struct HomeButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .backgroundStyle(configuration.isPressed ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: radius))
            .contentShape(.rect(cornerRadius: radius))
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
    
    private var radius: CGFloat {
        if #available(iOS 26, *) {
            26
        } else {
            10
        }
    }
    
}

extension ButtonStyle where Self == HomeButtonStyle {
    static var home: HomeButtonStyle { HomeButtonStyle() }
//    static func home() -> HomeButtonStyle {
//        HomeButtonStyle()
//    }
}

#Preview {
    ScrollView {
        Button {
            
        } label: {
            Text(verbatim: "Button")
        }
        .buttonStyle(.home)
        .padding()
    }
    .frame(maxWidth: .infinity)
    .background(Color(.systemGroupedBackground))
}
