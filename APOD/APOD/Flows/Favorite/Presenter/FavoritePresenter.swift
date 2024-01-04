//
//  FavoritePicturePresenter.swift
//  APOD
//
//  Created by Nata Kuznetsova on 29.11.2023.
//

import UIKit

protocol FavoritePresenterDelegate: AnyObject {
    func showError(error: Error, date: Date)
    func updateView(viewModels: [DataViewImage])
}

class FavoritePresenter {
    typealias PresenterDelegate = FavoritePresenterDelegate & UIViewController
    weak var delegate: PresenterDelegate?
    private var networkService = NetworkService()
    private var fileCache = DataStoreService()
    
}

extension FavoritePresenter: FavoritePresenterProtocol {
    func fetchPictures() -> [DataImage] {
        let models = fileCache.getFavoritePictures()
        return models
    }
    
    func deleteFavorite(date: String){
        fileCache.deletePicture(date: date)
        print("delete")
    }
    
}
