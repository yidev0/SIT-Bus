//
//  UIApplication +.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/22.
//


import UIKit.UIApplication

extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let firstKeyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow

        return firstKeyWindow
    }
}
