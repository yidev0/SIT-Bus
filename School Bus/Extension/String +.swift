//
//  String +.swift
//  School Bus
//
//  Created by Yuto on 2024/08/17.
//

import Foundation

extension String {
    func extractTime() -> String? {
        let pattern = #"(?:\b|^)([1-9]|0?[0-9]|1[0-9]|2[0-3]):[0-5]\d"#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsrange = NSRange(self.startIndex..<self.endIndex, in: self)
            
            if let match = regex.firstMatch(in: self, options: [], range: nsrange) {
                if let range = Range(match.range, in: self) {
                    return String(self[range])
                }
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }
        
        return nil
    }
}
