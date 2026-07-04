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
    var quickLookURL: URL?
    
    func getCoopSchedule(saveLocal: Bool) {
        Task {
            do {
                let fetchedHTML = try await fetchHTML(from: "https://www.univcoop.jp/sit/time/")
                let links = extractLinks(from: fetchedHTML, withClass: "link_btn")
                if saveLocal {
                    await loadSchedule(for: links)
                }
                self.coopSchedule = links.sorted(by: { $0.title > $1.title })
            } catch {
                print(error)
                getLocalSchedule()
            }
        }
    }
    
    func getFileURL(for title: String) -> URL? {
        let fileManager = FileManager.default
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("coop") else { return nil }
        return cachesDirectory.appendingPathComponent(title, conformingTo: .pdf)
    }
    
    private func getLocalSchedule() {
        let fileManager = FileManager.default
        if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("coop") {
            do {
                let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                coopSchedule = contents.map { $0.lastPathComponent }.map { (title: $0, href: "") }.sorted(by: { $0.title > $1.title })
            } catch {
                print("Error getting contents: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadSchedule(for data: [(title: String, href: String)]) async {
        let fileManager = FileManager.default
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("coop") else { return }
        
        if !fileManager.fileExists(atPath: cachesDirectory.path()) {
            try? fileManager.createDirectory(at: cachesDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        for data in data {
            let directory = cachesDirectory.appendingPathComponent(data.title, conformingTo: .pdf)
            if let url = URL(string: data.href), fileManager.fileExists(atPath: directory.path(percentEncoded: false)) == false {
                do {
                    let data = try await URLSession.shared.data(from: url)
                    try data.0.write(to: directory)
                } catch {
                    print(error)
                }
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
