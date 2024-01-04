//
//  ImagePreviewScreenBuilder.swift
//  APOD
//
//  Created by Alexander Rubtsov on 09.12.2023.
//

import UIKit

struct  ImagePreviewScreenBuilder {
    static func build(image: UIImage) -> UIViewController {
        let viewController = ImagePreviewScreenViewController()
        let presenter = ImagePreviewScreenPresenter(image: image)
        presenter.delegate = viewController
        viewController.presenter = presenter
        return viewController
    }
}
