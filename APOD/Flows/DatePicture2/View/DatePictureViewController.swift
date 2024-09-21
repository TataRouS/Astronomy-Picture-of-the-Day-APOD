//
//  DatePictureViewController.swift
//  APOD
//
//  Created by Irina on 05.01.2024.
//

import UIKit

protocol DatePictureProtocol {
    func viewDidLoad()
    func didTapRetryButton()
    func didTapFavoriteButton()
    func didPullToRefresh()
    func didTapNavBarActionButton()
    func onImageTap()
}

enum DatePictureScreenState {
    case error(DatePictureError)
    case loading
    case loaded(DatePictureViewModel)
}

class DatePictureViewController: UIViewController {
    
    //MARK: - Properties
    
    var presenter: DatePictureProtocol?
    
    //MARK: - Private properties
    
    private var contentView = DatePictureContentView()
    private var loadingView = DatePictureLoadingView()
    private var errorView = DatePictureErrorView()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Functions
    
    @objc func didTapNavBarActionButton() {
        presenter?.didTapNavBarActionButton()
    }
    
    // MARK: - Private functions
    
    private func setupViews(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapNavBarActionButton))
        
        contentView.onTapPresenterController = { [weak self] _ in
            self?.presenter?.didTapFavoriteButton()
        }
        contentView.onPullToRefreshr = { [weak self] in
            self?.presenter?.didPullToRefresh()
        }
        contentView.onImageTap = { [weak self] in
            self?.presenter?.onImageTap()
            
        }
        
        view.backgroundColor = .white

        contentView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorView)
        view.addSubview(loadingView)
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
  
extension DatePictureViewController: DatePicturePresenterDelegate {
    func present(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false)
    }
    
    func showShareSheet(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    func showState(_ newState: DatePictureScreenState) {
        DispatchQueue.main.async { [weak self] in
            self?.resetState()
        
            switch newState {
            case .loading:
                self?.processLoadingState()
//            case .error(let error):
//                self?.processErrorState(error)
            case .loaded(let model):
                self?.processLoadedState(model)
            case .error(_): break
                
            }
        }
    }
    
    func processLoadingState() {
        loadingView.isHidden = false
        loadingView.setActivityIndicatorAnimating(isAnimating: true)
    }
    
    func processErrorState(_ error: PictureOfDayError) {
        errorView.isHidden = false
        
        switch error {
        case .unknownError:
            let errorViewModel = DatePictureErrorViewModel(title: "Не получилось разобрать\nответ от сервера",
                                                            subtitle: nil,
                                                            buttonTitle: "Попробовать снова")
            errorView.setupData(errorViewModel)
        case .networkError(let error):
            let errorViewModel = DatePictureErrorViewModel(title: "Упс! Произошла ошибка сети",
                                                            subtitle: error.localizedDescription,
                                                            buttonTitle: "Обновить")
            errorView.setupData(errorViewModel)
        }
    }
    
    func processLoadedState(_ contentModel: DatePictureViewModel) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = contentModel.title
        contentView.setupViewWithModel(contentModel)
        contentView.isHidden = false
    }
    
    func resetState() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        title = ""
        contentView.isHidden = true
        loadingView.isHidden = true
        errorView.isHidden = true
        
        loadingView.setActivityIndicatorAnimating(isAnimating: false)
    }
}

extension DatePictureViewController: DatePictureErrorViewDelegate {
    func didTapRetryButton() {
        presenter?.didTapRetryButton()
    }
}

