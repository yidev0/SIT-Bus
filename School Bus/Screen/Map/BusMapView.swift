//
//  BusMapView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/05.
//

import SwiftUI
import MapKit

struct BusMapView: View {
    var body: some View {
        List {
            BusMapSection("Label.SchoolBusOmiya") {
                Marker(
                    "Label.Map.FromHigashiOmiya",
                    systemImage: "tram.fill",
                    coordinate: .fromHigashiOmiya
                )
                
                Marker(
                    "Label.Map.ToHigashiOmiya",
                    systemImage: "graduationcap.fill",
                    coordinate: .toHigashiOmiya
                )
            }
            
            BusMapSection("Label.SchoolBusIwatsuki") {
                Marker(
                    "Label.Map.FromIwatsuki",
                    systemImage: "tram.fill",
                    coordinate: .fromIwatsuki
                )
                
                Marker(
                    "Label.Map.ToIwatsuki",
                    systemImage: "graduationcap.fill",
                    coordinate: .toIwatsuki
                )
            }
        }
        .tint(.accentColor)
    }
}

private struct BusMapSection<Content: MapContent>: View {
    
    var heading: LocalizedStringKey
    
    @MapContentBuilder
    var content: () -> Content
    
    init(
        _ heading: LocalizedStringKey,
        @MapContentBuilder content: @escaping () -> Content
    ) {
        self.heading = heading
        self.content = content
    }
    
    var body: some View {
        Section {
            Map {
                content()
            }
            .aspectRatio(1.618, contentMode: .fit)
            .listRowInsets(.init())
        } header: {
            Text(heading)
        }
    }
}

#Preview {
    BusMapView()
}
