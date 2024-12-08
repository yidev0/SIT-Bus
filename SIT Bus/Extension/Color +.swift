//
//  Color +.swift
//  School Bus
//
//  Created by Yuto on 2024/08/23.
//

import SwiftUI

extension Color {
    /// Return a random color
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
