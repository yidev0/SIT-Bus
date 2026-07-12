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
    
    var title: LocalizedStringResource {
        switch self {
        case .univCoop:
            .univCoop
        case .boardingLocation:
            .boardingLocation
        case .library:
            .library
        case .festival:
            switch Date.now.get(.month) {
            case 1...6:
                .omiyaFestival
            default:
                .shibauraFestival
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
                            boardingLocations
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
                Text(.relatedSites)
                Spacer()
            }
            .font(.headline)
            .padding(.horizontal, 4)
        }
        .buttonStyle(.home)
    }
    
    private var boardingLocations: some View {
        List {
            Section {
                LinkButton("https://www.shibaura-it.ac.jp/access/omiya.html") {
                    Text(.schoolBusIwatsuki)
                }
                
                LinkButton("https://www.shibaura-it.ac.jp/access/omiya.html") {
                    Text(.schoolBusOmiya)
                }
                
                LinkButton(.init(localized: "URL.ShuttleBus")) {
                    Text(.shuttleBus)
                }
            }
        }
        .navigationTitle(.boardingLocation)
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
