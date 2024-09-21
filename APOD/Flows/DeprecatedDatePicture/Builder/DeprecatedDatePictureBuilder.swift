//
//  DataPictureBuilder.swift
//  APOD
//
//  Created by Irina on 25.11.2023.
//

import UIKit

struct DeprecatedDatePictureBuilder {
    static func build() -> UIViewController {
        let viewController = DeprecatedDatePictureController()
        let presenter = DeprecatedDatePicturePresenter()
        viewController.presenter = presenter
        presenter.delegate = viewController
        return viewController
    }
}
