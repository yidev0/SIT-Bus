//
//  SBCalendar.swift
//  School Bus
//
//  Created by Yuto on 2024/08/13.
//

import Foundation


struct SBCalendar: Decodable {
    /// ステータス（publicのみ）
    let status: String
    /// 該当カレンダー作成日時
    let edit_time: String
    /// 該当カレンダー更新日時
    let up_time: String
    /// 該当カレンダータイトル
    let title: String
    /// 該当カレンダーの年
    let year: String
    /// 該当カレンダーの月
    let month: String
    /// 補足情報1
    let text1: String
    /// 各日付毎の設定
    let list: [List]
    
    struct List: Decodable {
        /// 該当日の日付
        let day: String
        /// 該当日の時刻表個別ID
        let ts_id: String
        /// 該当日のコメント
        let comment: String
    }
    
    func getActiveDates() -> [Date] {
        var dates: [Date] = []
        for list in self.list {
            if list.ts_id != "none" && list.ts_id.isEmpty == false {
                if let year = Int(self.year), let month = Int(self.month), let day = Int(list.day),
                   let date = Date.createDate(year: year, month: month, day: day) {
                    dates.append(date)
                }
            }
        }
        
        return dates
    }
}
