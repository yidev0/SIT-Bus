//
//  SBSiteInfo.swift
//  School Bus
//
//  Created by Yuto on 2024/08/13.
//


struct SBSiteInfo: Decodable {
    ///  ステータス（editのみ）
    let status: String
    ///  サイト設定更新日時
    let up_time: String
    ///  公開ページのタイトル（大宮スクールバス時刻表カレンダー）
    let title: String
    ///  お知らせ欄表示非表示（on または off）
    let info_view: String
    ///  お知らせ欄タイトル（平常は「運行情報」）
    let info_title: String
    ///  お知らせ欄テキスト（平常は「運行情報はありません。」）
    let info_text: String
    ///  行き先記号設定
    let will: Direction
    
    struct Direction: Decodable {
        ///  上り方面の設定、
        let up: [Destination]
        /// 下り方面の設定
        let down: [Destination]
     
        struct Destination: Decodable {
            ///  編集用記号（例：a）
            let mark: String
            ///  表示用記号（例：上）
            let name: String
            ///  駅名（例：上野）
            let tip: String
        }
    }
}