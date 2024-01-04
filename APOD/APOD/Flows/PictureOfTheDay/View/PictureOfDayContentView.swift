//
//  PictureOfDayContentView.swift
//  APOD
//
//  Created by Nata Kuznetsova on 30.11.2023.
//

import Foundation
import UIKit

class PictureOfDayContentView: UIView {
    
    //MARK: - Properties
    
    var onTapPresenterController: ((Bool) -> Void)?
    var onPullToRefreshr: (() -> Void)?
    var onImageTap: (() -> Void)?
    
    //MARK: - Private properties
    
    private let addToFavoriteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private var addToFavoritesView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var scrollViewContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var starIsFilled: Bool = false
    
    // MARK: - Construction
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    func setupViewWithModel(_ contentModel: PictureOfDayViewModel) {
        scrollView.refreshControl?.endRefreshing()
        starIsFilled = contentModel.isFavorite
        updateFavoriteButtonState()
        imageView.image = contentModel.image
        descriptionLabel.text = contentModel.description
    }
    
    @objc func didTapFavoriteButton() {
        toggleFavorite()
        onTapPresenterController?(starIsFilled)
    }
    
    @objc func didPullToRefresh() {
        onPullToRefreshr?()
    }
    
    @objc func didTapImage() {
        onImageTap?()
    }
    
    //MARK: - Private functions
    
    private func setupViews() {
        let imageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(imageViewGestureRecognizer)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        addToFavoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        
        stackView.addArrangedSubview(addToFavoritesView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(addToFavoritesView)
        addToFavoritesView.addSubview(addToFavoriteButton)
        
        scrollViewContentView.addSubview(stackView)
        scrollView.addSubview(scrollViewContentView)
        addSubview(scrollView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            scrollViewContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollViewContentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor),
            
            addToFavoritesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addToFavoritesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            addToFavoriteButton.topAnchor.constraint(equalTo: addToFavoritesView.topAnchor, constant: 20),
            addToFavoriteButton.bottomAnchor.constraint(equalTo: addToFavoritesView.bottomAnchor, constant: -20),
            addToFavoriteButton.leadingAnchor.constraint(equalTo: addToFavoritesView.leadingAnchor, constant: 0),
            addToFavoriteButton.trailingAnchor.constraint(equalTo: addToFavoritesView.trailingAnchor, constant: 0),
            addToFavoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func toggleFavorite() {
        self.starIsFilled = !starIsFilled
        updateFavoriteButtonState()
    }
    
    private func updateFavoriteButtonState() {
        let starImageName = starIsFilled ? "star.fill": "star"
        addToFavoriteButton.setImage(UIImage(systemName: starImageName), for: .normal)
        addToFavoriteButton.backgroundColor = starIsFilled ? .systemGray4: .systemBlue
        addToFavoriteButton.setTitle(starIsFilled ? "Remove from favorite": "Add to favorite", for: .normal)
    }
}
