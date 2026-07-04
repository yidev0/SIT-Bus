//
//  Text +.swift
//  School Bus
//
//  Created by Yuto on 2024/08/18.
//

import SwiftUI

struct FilterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26, *) {
            configuration.label
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
        } else {
            configuration.label
                .font(.body)
                .foregroundStyle(Color.primary)
                .scaledToFill()
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background()
                .backgroundStyle(configuration.isPressed ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Color.secondary)
                }
                .contentShape(.capsule)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

extension ButtonStyle where Self == FilterButtonStyle {
    static var filter: FilterButtonStyle { FilterButtonStyle() }
}
