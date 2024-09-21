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
    
    //MARK: - Private properties
    
    private var starIsFilled: Bool = false
    
    private var labelTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
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
    
    private var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var labelDescriptions: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    private var scrollViewContentView = UIView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    func presentImage(apod: DataImage, data: Data, isFilledStar: Bool){
        DispatchQueue.main.async {
            if isFilledStar {
                self.button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }else{
                self.button.setImage(UIImage(systemName: "star"), for: .normal)
            }
            self.starIsFilled = isFilledStar
            self.imageView.image = UIImage(data: data)
            self.labelTitle.text = apod.title
            self.labelDescriptions.text = apod.explanation
        }
    }
    
    @objc func tap(){
        print("Power")
        if starIsFilled {
            button.setImage(UIImage(systemName: "star"), for: .normal)
            starIsFilled = false
        }else{
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starIsFilled = true
        }
        guard let onTapPresenterController = onTapPresenterController
        else {
            return
        }
        onTapPresenterController(starIsFilled)
    }
    
    
    
    //MARK: - Private functions
    
    
    private func setupViews() {
        print("setupViews")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        button.addGestureRecognizer(gestureRecognizer)
        
        headerStackView.addArrangedSubview(labelTitle)
        headerStackView.addArrangedSubview(button)
        
        stackView.addArrangedSubview(headerStackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelDescriptions)
        scrollViewContentView.addSubview(stackView)
        scrollView.addSubview(scrollViewContentView)
        addSubview(scrollView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labelDescriptions.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30),
            
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            labelDescriptions.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            labelDescriptions.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    private func toggleFavorite(starIsFilled: Bool){
        if starIsFilled {
            button.setImage(UIImage(systemName: "star"), for: .normal)
            self.starIsFilled = false
        }else{
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.starIsFilled = true
        }
    }
}
