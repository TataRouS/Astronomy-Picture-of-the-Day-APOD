//
//  FavoritesToCollectionViewController.swift
//  APOD
//
//  Created by Irina on 05.01.2024.
//

import UIKit
 
protocol FavoriteToCollectionPresenterProtocol: AnyObject {}

class FavoriteToCollectionViewController: UIViewController {
    
    //MARK: - Properties
    
    var presenter: FavoriteToCollectionPresenterProtocol?
    
    //MARK: - Private properties
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - Construction
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    //MARK: - Private functions
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


    
    
