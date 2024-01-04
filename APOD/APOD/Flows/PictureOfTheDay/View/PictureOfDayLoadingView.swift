//
//  PictureOfDayLoadingView.swift
//  APOD
//
//  Created by Nata Kuznetsova on 30.11.2023.
//

import Foundation
import UIKit

class PictureOfDayLoadingView: UIView {
    
    //MARK: - Private properties
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AvenirNext-Bold", size: 50)
        label.numberOfLines = 0
        label.text = "Astronomy\nPicture\nOf the\nDay"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    //MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setActivityIndicatorAnimating(isAnimating: Bool) {
        if isAnimating {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        backgroundColor = .white
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(loader)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
