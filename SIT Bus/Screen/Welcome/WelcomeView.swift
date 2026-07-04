//
//  OnboardingView.swift
//  SIT Bus
//
//  Created by Yuto on 2025/09/10.
//

import SwiftUI

struct WelcomeView: View {
    
    @Environment(\.dismiss)
    var dismiss
    
    @Environment(\.dynamicTypeSize)
    var dynamicTypeSize
    
    @AppStorage(UserDefaultsKeys.shownWelcome2)
    var welcome = false
    
    @ScaledMetric
    var imageSize = 36
    
    var body: some View {
        NavigationStack {
            if #available(iOS 26.0, *) {
                content
                    .scrollEdgeEffectStyle(.hard, for: .bottom)
                    .scrollEdgeEffectStyle(.soft, for: .top)
                    .listSectionSpacing(24)
                    .safeAreaInset(edge: .bottom) {
                        bottomButtom
                            .buttonStyle(.glassProminent)
                            .padding(.horizontal, 24)
                            .padding(.bottom)
                    }
            } else {
                VStack(spacing: 0) {
                    content
                        .listSectionSpacing(24)
                    
                    bottomButtom
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .overlay(alignment: .top) {
                            Divider()
                        }
                }
                .background(Color(.systemGroupedBackground))
            }
        }
    }
    
    var content: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Image(.appIconDisplayLarge)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                        .accessibilityLabel(.appIcon)
                    Spacer()
                }
                .listRowBackground(Color(.systemGroupedBackground))
            }
            
            Section(.features) {
                makeFeatureCell(
                    symbol: "clock",
                    title: .featureNextBus,
                    detail: .featureNextBusDetail
                )
                
                makeFeatureCell(
                    symbol: "table",
                    title: .featureTimetable,
                    detail: .featureTimetableDetail
                )
                
                makeFeatureCell(
                    symbol: "widget.small",
                    title: .featureWidget,
                    detail: .featureWidgetDetail
                )
            }
            
            Section(.disclaimer) {
                Text(.busInfoDetail)
                
                makeSourceCell(
                    title: .schoolBusOmiya,
                    url: "http://bus.shibaura-it.ac.jp/db/bus_data.json"
                )
                
                makeSourceCell(
                    title: .schoolBusIwatsuki,
                    url: "https://www.shibaura-it.ac.jp/assets/20250927.pdf"
                )
                
                makeSourceCell(
                    title: .shuttleBus,
                    url: "https://www.shibaura-it.ac.jp/assets/AAA.pdf"
                )
            }
        }
    }
    
    private var bottomButtom: some View {
        Button {
            welcome = true
            dismiss.callAsFunction()
        } label: {
            Text(.continue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .fontWeight(.bold)
        }
    }
    
    private func makeFeatureCell(
        symbol: String,
        title: LocalizedStringResource,
        detail: LocalizedStringResource
    ) -> some View {
        HStack {
            if dynamicTypeSize > .accessibility2 {
                EmptyView()
            } else {
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: imageSize)
                    .hidden()
                    .overlay {
                        Image(systemName: symbol)
                            .font(.title)
                            .foregroundStyle(.tint)
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                Text(detail)
                    .font(.subheadline)
            }
        }
        .accessibilityElement(children: .combine)
    }
    
    func makeSourceCell(
        title: LocalizedStringResource,
        url: String
    ) -> some View {
        Link(destination: .init(string: url)!) {
            VStack(alignment: .leading) {
                Text(title)
                Text(verbatim: url)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .tint(Color.primary)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    WelcomeView()
}
