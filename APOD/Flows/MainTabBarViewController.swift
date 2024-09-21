//
//  MainTabBarController.swift
//  APOD
//
//  Created by Irina on 02.12.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let daylyImageTabTitle = "Dayly image"
        static let favoritesTabTitle = "Favorites"
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createViewController(DailyPictureScreenBuilder.build(), image: UIImage(systemName: "photo"), titleBar: Constants.daylyImageTabTitle),
            // createViewController(DeprecatedDatePictureBuilder.build(),image: UIImage(systemName: "photo.on.rectangle"), titleBar: "Deprecated"),
            createViewController(FavoriteBuilder.build(), image: UIImage(systemName: "star.fill"), titleBar: Constants.favoritesTabTitle)
        ]
    }
    
    // MARK: - Private functions
    
    private func createViewController(_ viewController: UIViewController, image: UIImage?, titleBar: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.title = titleBar
        return navController
    }
}
