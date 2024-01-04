//
//  DataPicturePresenter.swift
//  APOD
//
//  Created by Irina on 26.11.2023.
//

import UIKit

protocol DatePicturePresenterDelegate: AnyObject {
    func updateUI(with photoinfo: DataImage)
    func showAlert()
}

class DatePicturePresenter {
    typealias PresenterDelegate = DatePicturePresenterDelegate & UIViewController
    weak var delegate: PresenterDelegate?
    private var networkService = NetworkService()
    private var fileCache = DataStoreService()
    
//    private func getImage(){
//        networkService.requestData(completion: {[weak self] result in
//            switch result {
//            case .success(let apod):
//                DispatchQueue.global ().async {
//                    if let url = URL (string: apod.hdurl ?? ""), let data = try? Data(contentsOf: url){
//                        self?.delegate?.updateUI(with: apod)
//                    }
//                }
//            case .failure(_):
//                self?.delegate?.showAlert()
//            }
//        })
//    }
}

extension DatePicturePresenter: DatePicturePresenterProtocol {
    func deleteFavorite(apod: DataImage) {
        fileCache.addPictureToFavoriteIfNeeded(apod: apod)
       // fileCache.deletePicture(date: apod)
    }
    
    func checkFavoriteByDate(date: String) -> Bool {
       return fileCache.isFavorite(date: date)
    }
    
    func addFavorite(apod: DataImage) {
        fileCache.addPictureToFavoriteIfNeeded(apod: apod)
    }
    
    func viewDidLoad() {
    //getImage()
    }
}

