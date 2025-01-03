//
//  View +.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/04.
//

import SwiftUI

extension View {
    
    func addAccessiblityTraits(for selection: Bool) -> some View {
        self
            .accessibilityAddTraits(selection ? [.isSelected]:[])
    }
    
    func makeListLink() -> some View {
        LabeledContent {
            Image(systemName: "arrow.up.right")
                .foregroundStyle(Color.primary.tertiary)
        } label: {
            self
        }
    }
    
}
