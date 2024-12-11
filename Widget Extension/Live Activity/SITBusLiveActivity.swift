//
//  Widget_ExtensionLiveActivity.swift
//  Widget Extension
//
//  Created by Yuto on 2024/12/08.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SITBusLiveActivity: Widget {
    
    @State var currentDate: Date = .now
    let timer = Timer.publish(every: 0.3, on: .main, in: .default).autoconnect()
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SITBusActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(alignment: .leading, spacing: 12) {
                Text(context.attributes.busType.localizedTitle)
                    .fontWeight(.medium)
                    .font(.subheadline)
                Text(currentDate, format: .dateTime.second())
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    if let nextBusTime = context.state.nextBusTime {
                        Text(nextBusTime, style: .time)
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("Label.DepartsIn\(context.state.remainingMinutes)Minutes")
                    } else {
                        Text("Label.NoBusService")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                    }
                }
            }
            .padding()
            .onReceive(timer) { _ in
                currentDate = .now
            }
//            .activityBackgroundTint(Color.cyan)
//            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    HStack(
                        alignment: .firstTextBaseline,
                        spacing: 16
                    ) {
                        Label {
                            Text(context.attributes.busType.localizedShortTitle)
                        } icon: {
                            Image(systemName: "bus.fill")
                        }
                        
                        Spacer()
                        
                        if let nextBusTime = context.state.nextBusTime {
                            VStack {
//                                Text(nextBusTime, style: .time)
                                Text("Label.DepartsIn\(context.state.remainingMinutes)Minutes")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                            }
                        } else {
                            Text("Label.NoBusService")
                                .font(.body)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .fontWeight(.semibold)
                    .font(.title3)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    
                }
            } compactLeading: {
                Image(systemName: "bus.fill")
            } compactTrailing: {
                Text("Label.ShortMinutes\(context.state.remainingMinutes)", tableName: "Widget")
            } minimal: {
                Text(verbatim: "\(context.state.remainingMinutes)")
            }
//            .widgetURL(URL(string: "http://www.apple.com"))
//            .keylineTint(Color.red)
        }
    }
}

extension SITBusActivityAttributes {
    fileprivate static var preview: SITBusActivityAttributes {
        SITBusActivityAttributes(busType: .campusToStation)
    }
}

extension SITBusActivityAttributes.ContentState {
    fileprivate static var smiley: SITBusActivityAttributes.ContentState {
        SITBusActivityAttributes.ContentState(
            nextBusTime: .now,
            remainingMinutes: 5
        )
    }
    
    fileprivate static var starEyes: SITBusActivityAttributes.ContentState {
        SITBusActivityAttributes.ContentState(remainingMinutes: 10)
    }
}

#Preview("Notification", as: .content, using: SITBusActivityAttributes.preview) {
    SITBusLiveActivity()
} contentStates: {
    SITBusActivityAttributes.ContentState.smiley
    SITBusActivityAttributes.ContentState.starEyes
}

#Preview("Notification", as: .dynamicIsland(.expanded), using: SITBusActivityAttributes.preview) {
    SITBusLiveActivity()
} contentStates: {
    SITBusActivityAttributes.ContentState.smiley
    SITBusActivityAttributes.ContentState.starEyes
}

#Preview("Notification", as: .dynamicIsland(.compact), using: SITBusActivityAttributes.preview) {
    SITBusLiveActivity()
} contentStates: {
    SITBusActivityAttributes.ContentState.smiley
    SITBusActivityAttributes.ContentState.starEyes
}
