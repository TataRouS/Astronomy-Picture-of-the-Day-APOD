//
//  DataPictureBuilder.swift
//  APOD
//
//  Created by Irina on 25.11.2023.
//

import UIKit

struct DatePictureBuilder {
    static func build() -> UIViewController {
        let viewController = DatePictureController()
        let presenter = DatePicturePresenter()
        viewController.presenter = presenter
        presenter.delegate = viewController
        return viewController
    }
}
