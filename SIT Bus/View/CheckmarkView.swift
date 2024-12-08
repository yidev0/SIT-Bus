//
//  CheckmarkView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/19.
//

import SwiftUI

struct CheckmarkView: View {
    
    var isSelected: Bool
    var hideCircle = false
    
    var body: some View {
        switch (isSelected, hideCircle) {
        case (true, _):
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.accentColor)
                .font(.title3)
                .fontWeight(.semibold)
        case (false, false):
            Image(systemName: "circle")
                .foregroundColor(.secondary)
                .font(.title3)
                .fontWeight(.semibold)
        case (false, true):
            EmptyView()
        }
    }
}

#Preview {
    VStack {
        CheckmarkView(isSelected: false)
        CheckmarkView(isSelected: false, hideCircle: true)
        CheckmarkView(isSelected: true)
    }
}
