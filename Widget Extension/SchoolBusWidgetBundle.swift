//
//  Widget_ExtensionBundle.swift
//  Widget Extension
//
//  Created by Yuto on 2024/12/08.
//

import WidgetKit
import SwiftUI

@main
struct SITBusWidgetBundle: WidgetBundle {
    var body: some Widget {
        SITBusWidget()
        Widget_ExtensionLiveActivity()
    }
}
