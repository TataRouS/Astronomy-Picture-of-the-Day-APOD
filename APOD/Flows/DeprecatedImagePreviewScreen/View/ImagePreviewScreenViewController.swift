//
//  ImagePreviewScreenViewController.swift
//  APOD
//
//  Created by Alexander Rubtsov on 09.12.2023.
//

import Foundation
import UIKit
import DGZoomableImageView

protocol ImagePreviewScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didDoubleTappImage()
    func didTapCrossButton()
}

class ImagePreviewScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ImagePreviewScreenPresenterProtocol?
    
    // MARK: - Private properties
    
    private var imageView: DGZoomableImageView = {
        let imageView = DGZoomableImageView()
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var crossButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Functions
    
    @objc func didDoubleTappImage() {
        presenter?.didDoubleTappImage()
    }
    
    @objc func didTapCrossButton() {
        presenter?.didTapCrossButton()
    }
    
    // MARK: - Private functions
    
    private func setupViews() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTappImage))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        
        crossButton.addTarget(self, action: #selector(didTapCrossButton), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(crossButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            crossButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            crossButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            crossButton.widthAnchor.constraint(equalToConstant: 30),
            crossButton.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
}

extension ImagePreviewScreenViewController: ImagePreviewScreenPresenterDelegate {
    func presentImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func dismissScreen() {
        dismiss(animated: false)
    }
}
