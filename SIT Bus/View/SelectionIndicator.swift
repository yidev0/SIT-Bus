//
//  SelectionIndicator.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//


import SwiftUI

extension View {
    func selectionIndicator(
        selected: Bool,
        alignment: HorizontalAlignment = .trailing,
        spacing: CGFloat = 8
    ) -> some View {
        return SelectionIndicator(
            selected: selected,
            alignment: alignment,
            spacing: spacing
        ) {
            self
        }
    }
}

private struct SelectionIndicator<Content: View>: View {
    
    var selected: Bool
    var alignment: HorizontalAlignment
    var spacing: CGFloat = 8
    var content: () -> Content
    
    var body: some View {
        HStack(spacing: spacing) {
            switch alignment {
            case .leading:
                CheckmarkView(isSelected: selected)
            default:
                EmptyView()
            }
            
            content()
            
            switch alignment {
            case .leading:
                Spacer()
            case .trailing:
                Spacer()
                CheckmarkView(isSelected: selected)
            default:
                EmptyView()
            }
        }
        .accessibilityAddTraits(traits(for: selected))
    }
    
    func traits(for selection: Bool) -> AccessibilityTraits{
        if selected {
            return [.isSelected]
        } else {
            return []
        }
    }
}

#Preview {
    SelectionIndicator(selected: true, alignment: .leading) {
        Text("sample")
    }
}
