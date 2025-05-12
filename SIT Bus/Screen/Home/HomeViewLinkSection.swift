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
        if Date.now <= Date.createDate(year: 2025, month: 5, day: 19)! && Date.now >= Date.createDate(year: 2025, month: 4, day: 1)! {
            [.festival, .boardingLocation, .univCoop, .library]
        } else {
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
            "Label.OmiyaFestival"
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
    @Previewable @State var model = HomeViewModel()
    
    NavigationStack {
        ScrollView {
            HomeViewLinkSection()
                .environment(model)
        }
        .backgroundStyle(Color(.systemGroupedBackground))
    }
}
