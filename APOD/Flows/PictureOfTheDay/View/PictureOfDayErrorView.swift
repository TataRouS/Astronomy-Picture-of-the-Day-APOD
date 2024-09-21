//
//  PictureOfDayErrorView.swift
//  APOD
//
//  Created by Nata Kuznetsova on 30.11.2023.
//

import Foundation
import UIKit

protocol PictureOfDayErrorViewDelegate: AnyObject {
    func didTapRetryButton()
}
    
class PictureOfDayErrorView: UIView {
    
    private struct Constants {
        static let labelFontName = "AvenirNext-DemiBold"
    }
    
    //MARK: - Properties

    var delegate: PictureOfDayErrorViewDelegate?
    
    //MARK: - Private properties

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont(name: Constants.labelFontName, size: 30)
        label.numberOfLines = 0
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont(name: Constants.labelFontName, size: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.labelFontName, size: 15)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    // Init
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    func setupData(_ errorModel: PictureOfDayErrorViewModel) {
        titleLabel.text = errorModel.title
        subtitleLabel.text = errorModel.subtitle
        button.setTitle(errorModel.buttonTitle, for: .normal)
    }
    
    @objc func didTapButton() {
        delegate?.didTapRetryButton()
    }
    
    //MARK: - Private functions
    
    private func setupViews() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(button)
        addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.widthAnchor.constraint(equalToConstant: 300),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
