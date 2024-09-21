//
//  PictureOfTheDayWidgetLiveActivity.swift
//  PictureOfTheDayWidget
//
//  Created by Alexander Rubtsov on 10.12.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PictureOfTheDayWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PictureOfTheDayWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PictureOfTheDayWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PictureOfTheDayWidgetAttributes {
    fileprivate static var preview: PictureOfTheDayWidgetAttributes {
        PictureOfTheDayWidgetAttributes(name: "World")
    }
}

extension PictureOfTheDayWidgetAttributes.ContentState {
    fileprivate static var smiley: PictureOfTheDayWidgetAttributes.ContentState {
        PictureOfTheDayWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PictureOfTheDayWidgetAttributes.ContentState {
         PictureOfTheDayWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PictureOfTheDayWidgetAttributes.preview) {
   PictureOfTheDayWidgetLiveActivity()
} contentStates: {
    PictureOfTheDayWidgetAttributes.ContentState.smiley
    PictureOfTheDayWidgetAttributes.ContentState.starEyes
}
