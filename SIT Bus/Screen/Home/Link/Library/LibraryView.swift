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
    
    @AppStorage(UserDefaultsKeys.hideGoogleCalendar)
    var hideCalendar: Bool = false
    
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
                makeLink(
                    url: "https://library.shibaura-it.ac.jp/portal/portal/selectLogin/",
                    title: "My Library"
                )
                
                makeLink(
                    url: "https://library.shibaura-it.ac.jp/opc/",
                    title: "OPAC"
                )
            }
            
            if hideCalendar {
                Section {
                    makeLink(
                        url: "URL.LibraryService".localize,
                        title: "Label.LibraryServices"
                    )
                    
                    makeLink(
                        url: "https://lib.shibaura-it.ac.jp/usage/schedule",
                        title: "Label.Schedule"
                    )
                }
            } else {
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
            }
        }
        .listSectionSpacing(16)
    }
    
    func makeLink(url: String, title: LocalizedStringKey) -> some View {
        LinkButton(url) {
            Text(title)
        }
    }
}

#Preview {
    LibraryView()
}
