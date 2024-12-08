//
//  Widget_ExtensionBundle.swift
//  Widget Extension
//
//  Created by Yuto on 2024/12/08.
//

import WidgetKit
import SwiftUI

@main
struct Widget_ExtensionBundle: WidgetBundle {
    var body: some Widget {
        Widget_Extension()
        Widget_ExtensionLiveActivity()
    }
}
