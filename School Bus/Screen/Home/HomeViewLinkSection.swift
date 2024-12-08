//
//  HomeViewLinkSection.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI

struct HomeViewLinkSection: View {
    
    @Environment(HomeViewModel.self) private var model
    
    var body: some View {
        Section {
            VStack(spacing: 8) {
                NavigationLink {
                    CoopServiceView()
                } label: {
                    makeLabel("Label.UnivCoop")
                }
                
                NavigationLink {
                    BusMapView()
                } label: {
                    makeLabel("Label.BoardingLocation")
                }
            }
        } header: {
            HStack {
                Text("Label.RelatedSites")
                Spacer()
            }
            .font(.headline)
        }
        .buttonStyle(.home)
    }
    
    func makeLabel(_ key: LocalizedStringKey) -> some View {
        HStack {
            Text(key)
                .fontWeight(.medium)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background()
    }
}

#Preview {
    @Previewable @State var model = HomeViewModel()
    ScrollView {
        HomeViewLinkSection()
            .environment(model)
    }
    .backgroundStyle(Color(.systemGroupedBackground))
}
