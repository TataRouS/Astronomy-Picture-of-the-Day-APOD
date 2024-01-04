//
//  PictureOfTheDayWidgetBundle.swift
//  PictureOfTheDayWidget
//
//  Created by Alexander Rubtsov on 10.12.2023.
//

import WidgetKit
import SwiftUI

@main
struct PictureOfTheDayWidgetBundle: WidgetBundle {
    var body: some Widget {
        PictureOfTheDayWidget()
        PictureOfTheDayWidgetLiveActivity()
    }
}
