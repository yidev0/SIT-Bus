//
//  GroupBox +.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI

struct ColoredGroupBox: GroupBoxStyle {
    
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .backgroundStyle(color)
    }
}
