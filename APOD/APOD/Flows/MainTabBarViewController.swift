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
            createViewController(PictureOfDayBuilder.build(), title: "APOD", image: UIImage(systemName: "photo")),
            createViewController(DatePictureBuilder.build(), title: "DateAPOD", image: UIImage(systemName: "photo.on.rectangle")),
            createViewController(FavoriteBuilder.build(), title: "Favorite", image: UIImage(systemName: "star.fill"))
        ]
    }
    
    //MARK: - Private functions
    
    private func createViewController(_ viewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
