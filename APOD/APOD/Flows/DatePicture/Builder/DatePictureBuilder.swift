//
//  DataPictureBuilder.swift
//  APOD
//
//  Created by Irina on 25.11.2023.
//

import UIKit

struct DatePictureBuilder {
    
    static func build() -> UIViewController {
        let dataStoreService = DataStoreService()
        let presenter = DatePicturePresenter(networkService: NetworkService(),
                                              dataStoreService: dataStoreService)
        dataStoreService.delegate = presenter
        let viewController = DatePictureViewController()
        viewController.presenter = presenter
        presenter.delegate = viewController
        return viewController
    
//    static func build() -> UIViewController {
//        let viewController = DatePictureController()
//        let presenter = DatePicturePresenter()
//        viewController.presenter = presenter
//        presenter.delegate = viewController
//        return viewController
    }
}
