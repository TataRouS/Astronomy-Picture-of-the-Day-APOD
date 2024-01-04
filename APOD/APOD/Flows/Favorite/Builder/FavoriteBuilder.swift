//
//  FavoriteBuilder.swift
//  APOD
//
//  Created by Nata Kuznetsova on 03.12.2023.
//

import UIKit

struct FavoriteBuilder {
    static func build() -> UIViewController {
        let viewController = Favorite()
        let presenter = FavoritePresenter()
        viewController.presenter = presenter
        presenter.delegate = viewController
        return viewController
    }
}
