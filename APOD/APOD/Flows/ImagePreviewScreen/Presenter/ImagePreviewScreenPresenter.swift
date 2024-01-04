//
//  ImagePreviewScreenPresenter.swift
//  APOD
//
//  Created by Alexander Rubtsov on 09.12.2023.
//

import UIKit

protocol ImagePreviewScreenPresenterDelegate: AnyObject {
    func presentImage(_ image: UIImage)
    func dismissScreen()
}

class ImagePreviewScreenPresenter {
    weak var delegate: ImagePreviewScreenPresenterDelegate?
    
    // MARK: - Private properties
    
    private let image: UIImage
    
    // MARK: - Construction
    
    init(image: UIImage) {
        self.image = image
    }
}

extension ImagePreviewScreenPresenter: ImagePreviewScreenPresenterProtocol {
    func didTapCrossButton() {
        delegate?.dismissScreen()
    }
    
    func didDoubleTappImage() {
        delegate?.dismissScreen()
    }
    
    func viewDidLoad() {
        delegate?.presentImage(image)
    }
}
