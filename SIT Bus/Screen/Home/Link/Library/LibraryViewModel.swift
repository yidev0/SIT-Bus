//
//  LibraryViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/21.
//

import Foundation
import UIKit.UIApplication

@Observable
class LibraryViewModel {
    var sitSearch = ""
    
    func search() {
        if sitSearch.isEmpty { return }
        let locale = Locale.current.identifier == "ja_JP" ? "jp" : "en"
        let urlString = "https://sit.summon.serialssolutions.com/#!/search?pn=1&ho=t&include.ft.matches=f&l=\(locale)&q="
        let encodedQuery = sitSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedQuery, let url = URL(string: urlString + encodedQuery) {
            UIApplication.shared.open(url)
        }
    }
}
