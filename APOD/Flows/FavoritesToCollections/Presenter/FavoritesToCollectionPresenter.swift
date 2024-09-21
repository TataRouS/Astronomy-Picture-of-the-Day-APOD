//
//  FavoritesToCollectionPresenter.swift
//  APOD
//
//  Created by Irina on 05.01.2024.
//

import UIKit

protocol FavoriteToCollectionPresenterDelegate: AnyObject {
    
}

class FavoriteToCollectionPresenter {
    typealias PresenterDelegate = FavoriteToCollectionPresenterDelegate & UIViewController
    weak var delegate: PresenterDelegate?
    
}

extension FavoriteToCollectionPresenter: FavoriteToCollectionPresenterProtocol {
    
}
