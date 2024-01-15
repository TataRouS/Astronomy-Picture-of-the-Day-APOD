//
//  DatePictureBuilder2.swift
//  APOD
//
//  Created by Irina on 05.01.2024.
//

import UIKit

struct  DatePictureBuilder {
    static func build() -> UIViewController {
        let dataStoreService = DataStoreService()
        let presenter = DatePicturePresenter(networkService: NetworkService(),
                                              dataStoreService: dataStoreService)
        dataStoreService.delegate = presenter
        let viewController = DatePictureViewController()
        viewController.presenter = presenter
        presenter.delegate = viewController
        return viewController
    }
}
