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
        guard let encodedQuery = sitSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = "https://slib.shibaura-it.ac.jp/sublib/ja/nalis_sl/display_panel?searchTarget=0&kw=\(encodedQuery)&selectedLngOnly=0&selectSubject=1"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
