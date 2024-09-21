//
//  ApodScreenBuilder.swift
//  APOD
//
//  Created by Nata Kuznetsova on 23.11.2023.
//

import Foundation
import UIKit

struct  PictureOfDayBuilder {
    static func build() -> UIViewController {
        let dataStoreService = DataStoreService()
        let presenter = PictureOfDayPresenter(networkService: NetworkService(),
                                              dataStoreService: dataStoreService)
        dataStoreService.delegate = presenter
        let viewController = PictureOfTheDayViewController()
        viewController.presenter = presenter
        presenter.delegate = viewController
        return viewController
    }
}
