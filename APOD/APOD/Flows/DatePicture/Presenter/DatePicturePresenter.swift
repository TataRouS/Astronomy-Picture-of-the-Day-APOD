//
//  DataPicturePresenter.swift
//  APOD
//
//  Created by Irina on 26.11.2023.
//

import UIKit

protocol DatePicturePresenterDelegate: AnyObject {
    func showState(_ newState: DatePictureScreenState)
    func showShareSheet(image: UIImage)
    func present(_ viewController: UIViewController)
//    func updateUI(with photoinfo: DataImage)
//    func showAlert()
}

enum DatePictureError: Error {
    case unknownError
    case networkError(Error)
}

class DatePicturePresenter {
    typealias PresenterDelegate = DatePicturePresenterDelegate & UIViewController
    
    
    // MARK: - Properties
    
    weak var delegate: PresenterDelegate?
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceProtocol
    private let dataStoreService: DataStoreServiceProtocol
    private var currentImageModel: DataImage?
    private var currentImage: UIImage?
    
    // MARK: - Construction
    
    init(networkService: NetworkServiceProtocol,
         dataStoreService: DataStoreServiceProtocol) {
        self.networkService = networkService
        self.dataStoreService = dataStoreService
    }

    // MARK: - Private functions
    
    private func requestData() {
        delegate?.showState(.loading)

        networkService.requestData { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let apod):
                processSuccessResponse(apod)
            case .failure(let error):
                processFailureResponse(error)
            }
        }
    }
    
    private func requestDataForPicker(selectedDate: String) {
        delegate?.showState(.loading)

        networkService.fetchPhotoInfoForDatePicker (date: selectedDate)  { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let apod):
                processSuccessResponse(apod)
            case .failure(let error):
                processFailureResponse(error)
            }
        }
    }
    
    
    private func processSuccessResponse(_ responseModel: DataImage) {
        guard let image = extractUIImage(responseModel.hdurl) else {
            delegate?.showState(.error(.unknownError))
            return
        }
        var isFavorite = false
        if let strongDate = responseModel.date {
            isFavorite = dataStoreService.isFavorite(date: strongDate)
        }
        currentImageModel = responseModel
        currentImage = image
        
        let contentModel = DatePictureViewModel(isFavorite: isFavorite,
                                                 image: image,
                                                 title: responseModel.title,
                                                 description: responseModel.explanation)
        delegate?.showState(.loaded(contentModel))
    }
    
    private func processFailureResponse(_ error: Error) {
        delegate?.showState(.error(.networkError(error)))
    }
    
    private func extractUIImage(_ hdurl: String?) -> UIImage? {
        guard let strongHDUrl = hdurl,
              let url = URL (string: strongHDUrl),
              let data = try? Data(contentsOf: url),
              let uiimage = UIImage(data: data) else {
            return nil
        }
        return uiimage
    }
    
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

extension DatePicturePresenter: DatePictureProtocol {
    
    func onImageTap() {
        guard let image = currentImage else {
            return
        }
        
        let imagePreviewScreen = ImagePreviewScreenBuilder.build(image: image)
        delegate?.present(imagePreviewScreen)
    }
    
    func didTapNavBarActionButton() {
        guard let image = currentImage else {
            return
        }
        delegate?.showShareSheet(image: image)
    }
    
    func didTapFavoriteButton() {
        guard var strongCurrentImageModel = currentImageModel else {
            delegate?.showState(.error(.unknownError))
            return
        }
        
        strongCurrentImageModel.imageBinaryData = currentImage?.pngData()
        dataStoreService.addPictureToFavoriteIfNeeded(apod: strongCurrentImageModel)
    }

    func didTapRetryButton() {
        requestData()
    }
    
    func viewDidLoad() {
        requestData()
    }
    
    func didPullToRefresh() {
        requestData()
    }
    
    func didTapDatePicker(selectedDate: String) {
        requestDataForPicker(selectedDate: selectedDate)
    }
    
    
//    func deleteFavorite(apod: DataImage) {
//        fileCache.addPictureToFavoriteIfNeeded(apod: apod)
//       // fileCache.deletePicture(date: apod)
//        print("IfNEededdelete")
//    }
//    
//    func checkFavoriteByDate(date: String) -> Bool {
//       return fileCache.isFavorite(date: date)
//    }
//    
//    func addFavorite(apod: DataImage) {
//        fileCache.addPictureToFavoriteIfNeeded(apod: apod)
//        print("IfNEededAdd")
//    }
//    
//    func viewDidLoad() {
//    //getImage()
//    }
}

extension DatePicturePresenter: DataStoreServiceDelegate {
    func didReceiveError(_ error: DataStoreServiceError) {
        delegate?.showState(.error(.unknownError))
    }
}
