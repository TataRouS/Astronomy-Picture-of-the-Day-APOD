//
//  PictureOfDayViewModel.swift
//  APOD
//
//  Created by Alexander Rubtsov on 08.12.2023.
//

import Foundation
import UIKit

struct PictureOfDayViewModel {
    let isFavorite: Bool
    let image: UIImage?
    let title: String?
    let description: String?
}
