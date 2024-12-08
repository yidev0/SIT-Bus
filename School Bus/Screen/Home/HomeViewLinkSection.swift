//
//  HomeViewLinkSection.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI

fileprivate enum LinkType: Int, CaseIterable {
    case univCoop
    case boardingLocation
    
    var title: LocalizedStringKey {
        switch self {
        case .univCoop:
            "Label.UnivCoop"
        case .boardingLocation:
            "Label.BoardingLocation"
        }
    }
    
    var symbol: String {
        switch self {
        case .univCoop:
            "fork.knife"
        case .boardingLocation:
            "map.fill"
        }
    }
}

struct HomeViewLinkSection: View {
    
    @Environment(HomeViewModel.self) private var model
    @ScaledMetric var iconSize = 17
    
    var body: some View {
        Section {
            VStack(spacing: 8) {
                ForEach(LinkType.allCases, id: \.self) { type in
                    NavigationLink {
                        switch type {
                        case .univCoop:
                            CoopServiceView()
                        case .boardingLocation:
                            BusMapView()
                        }
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Image(systemName: type.symbol)
                                    .foregroundStyle(.accent)
                            }
                            .frame(width: iconSize)
                            
                            Text(type.title)
                                
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .fontWeight(.medium)
                        .padding()
                        .background()
                    }
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
}

#Preview {
    @Previewable @State var model = HomeViewModel()
    ScrollView {
        HomeViewLinkSection()
            .environment(model)
    }
    .backgroundStyle(Color(.systemGroupedBackground))
}
