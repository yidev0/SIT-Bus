//
//  CoopServiceViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2024/10/20.
//

import Foundation

@Observable
class CoopServiceViewModel {
    
    var coopSchedule: [(title: String, href: String)] = []
    
    public func getCoopSchedule() {
        Task {
            do {
                let fetchedHTML = try await fetchHTML(from: "https://www.univcoop.jp/sit/time/")
                let links = extractLinks(from: fetchedHTML, withClass: "link_btn")
                self.coopSchedule = links
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchHTML(from urlString: String) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return htmlString
    }

    private func extractLinks(from html: String, withClass className: String) -> [(title: String, href: String)] {
        var results: [(title: String, href: String)] = []
        
        let escapedClassName = NSRegularExpression.escapedPattern(for: className)
        let pattern = #"<a[^>]*class\s*=\s*['\"]\#(escapedClassName)['\"][^>]*href\s*=\s*['\"]([^'\"]+)['\"][^>]*title\s*=\s*['\"]([^'\"]+)['\"][^>]*>"#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
            
            for match in matches {
                if match.numberOfRanges == 3,
                   let hrefRange = Range(match.range(at: 1), in: html),
                   let titleRange = Range(match.range(at: 2), in: html) {
                    
                    let href = String(html[hrefRange])
                    let title = String(html[titleRange])
                    results.append((title: title, href: href))
                }
            }
        } catch {
            print("Invalid regular expression: \(error)")
        }
        
        return results
    }
}
