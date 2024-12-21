//
//  LibraryServiceView.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/21.
//

import SwiftUI
import WebUI

struct LibraryView: View {
    
    @State var model = LibraryViewModel()
    @FocusState var isFocused: Bool
    
    var body: some View {
        List {
            Section {
                LabeledContent {
                    Button {
                        model.search()
                    } label: {
                        Text("Label.Search")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(model.sitSearch.isEmpty)
                } label: {
                    TextField(text: $model.sitSearch) {
                        Text(verbatim: "SIT Search")
                    }
                    .focused($isFocused)
                    .onSubmit {
                        model.search()
                    }
                }
            }
            .listRowInsets(
                .init(top: 4, leading: 20, bottom: 4, trailing: 4)
            )
            .onTapGesture {
                isFocused.toggle()
            }
            
            Section {
                Link(destination: .init(string: "https://library1.shibaura-it.ac.jp/")!) {
                    LabeledContent {
                        Image(systemName: "arrow.up.right")
                    } label: {
                        Text(verbatim: "OPAC")
                    }
                }
            }
            
#if !targetEnvironment(simulator)
            Section("Label.Omiya") {
                WebView(request: .omiyaCalendarRequest)
                    .listRowInsets(.init())
                    .frame(height: 400)
            }
            
            Section("Label.Toyosu") {
                WebView(request: .toyosuCalendarRequest)
                    .listRowInsets(.init())
                    .frame(height: 400)
            }
#endif
        }
        .listSectionSpacing(16)
    }
}

#Preview {
    LibraryView()
}
