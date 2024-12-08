//
//  TopLabelGroupBox.swift
//  School Bus
//
//  Created by Yuto on 2024/08/17.
//

import SwiftUI

public struct TopLabelGroupBox: GroupBoxStyle {
    
    var spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            configuration.label
            GroupBox {
                configuration.content
            }
            .frame(maxWidth: .infinity)
        }
    }
}

extension GroupBoxStyle where Self == TopLabelGroupBox {
    public static func topLabel(spacing: CGFloat = 8) -> some GroupBoxStyle {
        TopLabelGroupBox(spacing: spacing)
    }
}
