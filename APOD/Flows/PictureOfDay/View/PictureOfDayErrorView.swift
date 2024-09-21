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
    
    //MARK: - Properties

    var delegate: PictureOfDayErrorViewDelegate?
    
    //MARK: - Private properties

    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        //label.backgroundColor = .white
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.text = "Oшибка загрузки данных из сети"
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle(" Попробовать снова ", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
    
    @objc func didTapButton() {
        delegate?.didTapRetryButton()
    }
    
    //MARK: - Private functions
    
    private func setupViews() {
        stackView.addArrangedSubview(label)
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

// label  ошибка загрузки данных из сети
//кнопка попробовать снова
//(через делегат просим презентер заного загрузить)
//протокол подключаю
//target: delegat:didTapRetryButton()



    

