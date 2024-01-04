//
//  ApodPresenter.swift
//  APOD
//
//  Created by Nata Kuznetsova on 17.11.2023.
//

import UIKit

protocol PictureOfDayPresenterDelegate: AnyObject {
    func showState(_ newState: PictureOfDayScreenState)
    func showShareSheet(image: UIImage)
    func present(_ viewController: UIViewController)
}

enum PictureOfDayError: Error {
    case unknownError
    case networkError(Error)
}

class PictureOfDayPresenter {
    typealias PresenterDelegate = PictureOfDayPresenterDelegate & UIViewController
    
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
        
        let contentModel = PictureOfDayViewModel(isFavorite: isFavorite,
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
}

extension PictureOfDayPresenter: PictureOfDayProtocol {
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
        guard let strongCurrentImageModel = currentImageModel else {
            delegate?.showState(.error(.unknownError))
            return
        }
        
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
}

extension PictureOfDayPresenter: DataStoreServiceDelegate {
    func didReceiveError(_ error: DataStoreServiceError) {
        delegate?.showState(.error(.unknownError))
    }
}
