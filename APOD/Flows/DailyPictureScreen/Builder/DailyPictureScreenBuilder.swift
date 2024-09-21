//
//  DailyPictureScreenBuilder.swift
//  APOD
//
//  Created by Nata Kuznetsova on 23.11.2023.
//

import Foundation
import UIKit

struct DailyPictureScreenBuilder {
    static func build() -> UIViewController {
        let dataStoreService = DataStoreService()
        let presenter = DailyPictureScreenPresenter(
            networkService: NetworkService(),
            dataStoreService: dataStoreService
        )
        dataStoreService.delegate = presenter
        let viewController = DailyPictureScreenViewController()
        viewController.presenter = presenter
        presenter.delegate = viewController
        return viewController
    }
}
