//
//  HomeViewLinkSection.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import SwiftUI

fileprivate enum LinkType: Int, CaseIterable {
    case festival
    case boardingLocation
    case univCoop
    case library
    
    static var allCases: [LinkType] {
        switch Date.now.get(.month) {
        case 4, 5, 10, 11:
            [.festival, .boardingLocation, .univCoop, .library]
        default:
            [.boardingLocation, .univCoop, .library]
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .univCoop:
            "Label.UnivCoop"
        case .boardingLocation:
            "Label.BoardingLocation"
        case .library:
            "Label.Library"
        case .festival:
            switch Date.now.get(.month) {
            case 1...6:
                "Label.OmiyaFestival"
            default:
                "Label.ShibauraFestival"
            }
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
        case .festival:
            "party.popper.fill"
        }
    }
}

struct HomeViewLinkSection: View {
    
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
                        case .festival:
                            HomeFestivalView()
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
            .padding(.horizontal, 4)
        }
        .buttonStyle(.home)
    }
}

#Preview {
    
    NavigationStack {
        ScrollView {
            HomeViewLinkSection()
        }
        .backgroundStyle(Color(.systemGroupedBackground))
    }
}
