//
//  SBTimeSheet.swift
//  School Bus
//
//  Created by Yuto on 2024/08/13.
//

import Foundation


struct SBTimeSheet: Decodable {
    ///  ステータス（publicのみ）
    let status: String
    ///  該当時刻表作成日時
    let edit_time: String
    ///  該当時刻表更新日時
    let up_time: String
    ///  該当時刻表タイトル
    let title: String
    ///  時刻表の個別ID
    let ts_id: String
    ///  時刻表の個別テーマカラー
    let back_color: String
    ///  補足情報1
    let text1: String
    ///  補足情報2
    let text2: String
    ///  補足情報3
    let text3: String
    ///  カレンダーで該当時刻表が設定されている日付に掲載されるテキスト
    let cal_text: String
    ///  各時刻毎の設定
    let list: [List]
    
    struct List: Decodable {
        ///  該当時刻（時間）
        let time: String
        /// バス（左側：駅前発）、JR（左側：下り）、JR（右側：上り）、バス（右側：校舎前発）それぞれで設定
        let station: Value
        /// バス（右側：校舎前発）
        let campus: Value
        /// JR（右側：上り）
        let trainUp: Value
        /// JR（左側：下り）
        let trainDown: Value
        
        struct Value: Decodable {
            /// 該当時刻の数値（分、ドット区切り）1行目
            let num1: String
            /// 該当時刻のメモ1行目
            let memo1: String
            /// 該当時刻の数値（分、ドット区切り）2行目
            let num2: String
            /// 該当時刻のメモ2行目
            let memo2: String
            
            func getTimes() -> [Int] {
                let firstNumbers = self.num1.split(separator: ".").compactMap({ Int($0) })
                let secondNumbers = self.num2.split(separator: ".").compactMap({ Int($0) })
                return (firstNumbers + secondNumbers).sorted()
            }
            
            func getNotes() -> String? {
                let note1 = memo1.isEmpty == false ? memo1:nil
                let note2 = memo2.isEmpty == false ? memo2:nil
                
                if let note1 = note1, let note2 = note2 {
                    return note1 + "\n" + note2
                } else if let note1 = note1 {
                    return note1
                } else if let note2 = note2 {
                    return note2
                } else {
                    return nil
                }
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case time
            case station = "bus_left"
            case trainDown = "train_left"
            case trainUp = "train_right"
            case campus = "bus_right"
        }
    }
    
    func makeTimetable(for type: BusLineType.SchoolBus) -> [TimetableValue] {
        var timetable: [TimetableValue] = .init()
        var lastNote: String?
        
        for list in self.list {
            if let hour = Int(list.time) {
                var times: [Int] = []
                var note: String? = nil
                var dateRange: [Date] = []
                
                switch type {
                case .campusToStation:
                    times = list.campus.getTimes()
                    note = list.campus.getNotes()
                case .stationToCampus:
                    times = list.station.getTimes()
                    note = list.station.getNotes()
                }
                
                switch (note?.contains("より") == true, note?.contains("まで") == true, lastNote?.isEmpty) {
                case (true, false, nil):
                    lastNote = note
                    note = nil
                case (false, true, false):
                    note = (lastNote?.extractTime() ?? "") + "より" + (note ?? "")
                    lastNote = nil
                default:
                    if note == "適時運行" {
                        lastNote = "\(hour):00"
                        note = nil
                    } else {
                        lastNote = nil
                    }
                }
                
                if let note {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    
                    let timePattern = "\\d{1,2}:\\d{2}"
                    
                    let regex = try! NSRegularExpression(pattern: timePattern, options: [])
                    let matches = regex.matches(in: note, options: [], range: NSRange(note.startIndex..., in: note))
                    
                    if matches.count == 2 {
                        for match in matches {
                            if let range = Range(match.range, in: note) {
                                let time = String(note[range])
                                if let date = dateFormatter.date(from: time) {
                                    dateRange.append(date)
                                }
                            }
                        }
                    }
                }
                
                timetable.append(
                    .init(
                        hour: hour,
                        times: times,
                        note: note,
                        dateRange1: dateRange.first,
                        dateRange2: dateRange.last
                    )
                )
            }
        }
        
        return timetable
    }
    
}
