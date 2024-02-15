//
//  MainTabBarController.swift
//  APOD
//
//  Created by Irina on 02.12.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createViewController(PictureOfDayBuilder.build(), image: UIImage(systemName: "photo"), titleBar: "APOD"),
            createViewController(DatePictureBuilder.build(),image: UIImage(systemName: "photo.on.rectangle"), titleBar: "DateAPOD"),
            createViewController(FavoriteBuilder.build(), image: UIImage(systemName: "star.fill"), titleBar: "Favorite"),
            createViewController(FavoriteToCollectionViewController(), image: UIImage(systemName: "heart"), titleBar: "Favorite")
        ]
    }
    
    //MARK: - Private functions
    
    private func createViewController(_ viewController: UIViewController, image: UIImage?, titleBar: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        //navController.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.title = titleBar
        return navController
    }
}
