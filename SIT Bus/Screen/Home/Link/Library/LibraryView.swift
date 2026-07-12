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
                        Text(.search)
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
                    title: .myLibrary
                )
                
                makeLink(
                    url: "https://library.shibaura-it.ac.jp/opc/",
                    title: .libraryOPAC
                )
            }
            
            if hideCalendar {
                Section {
                    makeLink(
                        url: String(localized: .urlLibraryService),
                        title: .libraryServices
                    )
                    
                    makeLink(
                        url: "https://lib.shibaura-it.ac.jp/usage/schedule",
                        title: .schedule
                    )
                }
            } else {
                Section(.omiya) {
                    WebView(request: .omiyaCalendarRequest)
                        .listRowInsets(.init())
                        .frame(height: 400)
                }
                
                Section(.toyosu) {
                    WebView(request: .toyosuCalendarRequest)
                        .listRowInsets(.init())
                        .frame(height: 400)
                }
            }
        }
        .listSectionSpacing(16)
    }
    
    func makeLink(url: String, title: LocalizedStringResource) -> some View {
        LinkButton(url) {
            Text(title)
        }
    }
}

#Preview {
    LibraryView()
}
