//
//  DetailedFavorite.swift
//  APOD
//
//  Created by Irina on 26.04.2024.
//

import UIKit

class DetailedFavorite: UIViewController {
    
    //функция относится к "сохранить или передать"
    lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
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
    
    private var labelTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var labelDescriptions: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var scrollViewContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(with viewModels: DataViewImage) {
        super.init(nibName: nil, bundle: nil)
        
        labelTitle.text = viewModels.title
        labelDescriptions.text = viewModels.explanation
        imageView.image = UIImage(data: viewModels.data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapGesture))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapGesture(gesture:UITapGestureRecognizer) {
        guard let image = imageView.image else {
            return
        }
        let imagePreviewScreen = ImagePreviewScreenBuilder.build(image: image)
        imagePreviewScreen.modalPresentationStyle = .fullScreen
        present(imagePreviewScreen, animated: false)
    }
    
    //функция относится к "сохранить или передать"
    @objc private func actionBarButtonTapped() {
        let shareController = UIActivityViewController(activityItems: [imageView.image as Any], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }

    
    private func setupView() {
        
        navigationItem.rightBarButtonItem = actionBarButtonItem
        
        stackView.addArrangedSubview(labelTitle)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelDescriptions)
        
        scrollViewContentView.addSubview(stackView)
        scrollView.addSubview(scrollViewContentView)
        view.addSubview(scrollView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            scrollViewContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollViewContentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor),
            
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            labelDescriptions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelDescriptions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
}

