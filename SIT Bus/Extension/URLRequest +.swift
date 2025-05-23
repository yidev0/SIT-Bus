//
//  URLRequest +.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/21.
//

import Foundation.NSURL

extension URLRequest {
    static var omiyaCalendarRequest = URLRequest(
        url: URL(string: "https://calendar.google.com/calendar/embed?showTitle=0&showPrint=0&showTabs=0&showTz=0&wkst=2&bgcolor=%23FFFFFF&src=v64m86j7salho2siqe245um6f4@group.calendar.google.com&color=%23c1d3ce&src=qg07b17dftf5b3ki7gu6asnavs@group.calendar.google.com&color=%23064e3c&ctz=Asia/Tokyo")!
    )
    
    static var toyosuCalendarRequest = URLRequest(
        url: URL(string: "https://calendar.google.com/calendar/embed?showTitle=0&showPrint=0&showTabs=0&showTz=0&wkst=2&bgcolor=%23ffffff&ctz=Asia%2FTokyo&src=bGliZXR1cmFuQGdtYWlsLmNvbQ&src=MWU1OWs5bmNwc2JhNXBhbzhpYWwyZGEycDBAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ&color=%2335c759&color=%23ccf1d6")!
    )
    
    static var festivalRequest = URLRequest(
        url: URL(string: "https://oomiya-fes-sit.net/?utm_source=sitbusapp")!
    )
}
