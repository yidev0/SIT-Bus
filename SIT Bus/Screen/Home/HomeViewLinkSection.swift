//
//  HomeViewLinkSection.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI

fileprivate enum LinkType: Int, CaseIterable {
    case boardingLocation
    case univCoop
    case library
    
    var title: LocalizedStringKey {
        switch self {
        case .univCoop:
            "Label.UnivCoop"
        case .boardingLocation:
            "Label.BoardingLocation"
        case .library:
            "Label.Library"
        }
    }
    
    var symbol: String {
        switch self {
        case .univCoop:
            "fork.knife"
        case .boardingLocation:
            "map.fill"
        case .library:
            "books.vertical.fill"
        }
    }
}

struct HomeViewLinkSection: View {
    
    @Environment(HomeViewModel.self) private var model
    
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
                        case .library:
                            LibraryView()
                        }
                    } label: {
                        HomeLinkCell(
                            title: type.title,
                            symbol: type.symbol,
                            trailingSymbol: "chevron.right"
                        )
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
