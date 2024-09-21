//
//  FavoritesToCollectionBuilder.swift
//  APOD
//
//  Created by Irina on 05.01.2024.
//

import UIKit

struct FavoritesToCollectionBuilder {
    static func build() -> UIViewController {
        let viewController = FavoriteToCollectionViewController()
        let presenter = FavoriteToCollectionPresenter()
        viewController.presenter = presenter
        presenter.delegate = viewController as? any FavoriteToCollectionPresenter.PresenterDelegate
        return viewController
    }
}

