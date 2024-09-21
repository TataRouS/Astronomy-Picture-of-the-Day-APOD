//
//  DailyPictureScreenViewController+DailyPictureScreenPresenterDelegate.swift
//  APOD
//
//  Created by Alexander Rubtsov on 21.09.2024.
//

import UIKit

enum DailyPictureScreenState {
    case error(DailyPictureScreenError)
    case loading
    case loaded(DailyPictureScreenViewModel)
}

extension DailyPictureScreenViewController: DailyPictureScreenPresenterDelegate {
    
    // MARK: - Functions
    
    func present(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false)
    }
    
    func showShareSheet(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    func showState(_ newState: DailyPictureScreenState) {
        DispatchQueue.main.async { [weak self] in
            self?.resetState()
        
            switch newState {
            case .loading:
                self?.processLoadingState()
            case .error(let error):
                self?.processErrorState(error)
            case .loaded(let model):
                self?.processLoadedState(model)
            }
        }
    }
    
    // MARK: - Private functions
    
    private func resetState() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        title = ""
        tabBarItem.title = Constants.tabBarTitle
        contentView.isHidden = true
        loadingView.isHidden = true
        errorView.isHidden = true
        loadingView.setActivityIndicatorAnimating(isAnimating: false)
    }
    
    private func processLoadingState() {
        loadingView.isHidden = false
        loadingView.setActivityIndicatorAnimating(isAnimating: true)
    }
    
    private func processErrorState(_ error: DailyPictureScreenError) {
        errorView.isHidden = false
        
        switch error {
        case .unknownError:
            let errorViewModel = DailyPictureScreenErrorViewModel(
                title: Constants.networkUnknownErrorTitle,
                subtitle: nil,
                buttonTitle: Constants.networkUnknownErrorButtonTitle
            )
            errorView.setupData(errorViewModel)
        case .networkError(let error):
            let errorViewModel = DailyPictureScreenErrorViewModel(
                title: Constants.networkErrorTitle,
                subtitle: error.localizedDescription,
                buttonTitle: Constants.networkErrorButtonTitle
            )
            errorView.setupData(errorViewModel)
        }
    }
    
    private func processLoadedState(_ contentModel: DailyPictureScreenViewModel) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = contentModel.title
        tabBarItem.title = Constants.tabBarTitle
        contentView.setupViewWithModel(contentModel)
        contentView.isHidden = false
    }
}
