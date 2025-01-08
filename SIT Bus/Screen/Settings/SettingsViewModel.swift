//
//  SettingsViewModel.swift
//  SIT Bus
//
//  Created by Yuto on 2025/01/08.
//

import Foundation
import SafariServices

@Observable
class SettingsViewModel {
    
    var deletingCache: Bool = false
    var cacheSize: CGFloat? = nil
    
    func deleteCache() {
        Task {
            deletingCache = true
            await SFSafariViewController.DataStore.default.clearWebsiteData()
            
            let fileManager = FileManager.default
            if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("coop"), fileManager.fileExists(atPath: url.path()) == true {
                try fileManager.removeItem(at: url)
            }
            deletingCache = false
            
            updateCacheSize()
        }
    }
    
    func updateCacheSize() {
        let fileManager = FileManager.default
        var totalSize: Int64 = 0
        if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("coop") {
            do {
                let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [.fileSizeKey], options: .skipsHiddenFiles)
                for item in contents {
                    totalSize += getFileSize(at: item)
                }
            } catch {
                print("Error getting directory size: \(error.localizedDescription)")
            }
        }
        cacheSize = Double(totalSize) / 1024 / 1024
    }
    
    private func getFileSize(at url: URL) -> Int64 {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int64 ?? 0
        } catch {
            print("Error getting file size: \(error.localizedDescription)")
            return 0
        }
    }
    
}
