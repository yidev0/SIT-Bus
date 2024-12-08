//
//  View +.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/04.
//

import SwiftUI

extension View {
    public func addAccessiblityTraits(for selection: Bool) -> some View {
        self
            .accessibilityAddTraits(selection ? [.isSelected]:[])
    }
}
