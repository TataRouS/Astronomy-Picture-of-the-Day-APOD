//
//  ViewController.swift
//  APOD
//
//  Created by Nata Kuznetsova on 16.10.2023.
//

import UIKit

protocol DailyPictureScreenProtocol {
    func viewDidLoad()
    func didTapRetryButton()
    func didTapFavoriteButton()
    func didPullToRefresh()
    func didTapNavBarActionButton()
    func onImageTap()
}

class DailyPictureScreenViewController: UIViewController {
    
    // MARK: - Constants
    
    enum Constants {
        static let networkErrorTitle = "Упс! Произошла ошибка сети"
        static let networkErrorButtonTitle = "Обновить"
        static let networkUnknownErrorTitle = "Не получилось разобрать\nответ от сервера"
        static let networkUnknownErrorButtonTitle = "Попробовать снова"
        static let tabBarTitle = "APOD"
    }
    
    //MARK: - Properties
    
    var presenter: DailyPictureScreenProtocol?
    
    //MARK: - Private properties
    
    let contentView = DailyPictureScreenContentView()
    let loadingView = DailyPictureScreenLoadingView()
    let errorView = DailyPictureScreenErrorView()
    
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
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapNavBarActionButton)
        )
        
        view.backgroundColor = .white

        setupContentViewState()
        setupErrorViewState()
        setupLoadingViewState()
    }
    
    private func setupContentViewState() {
        contentView.onTapPresenterController = { [weak self] _ in
            self?.presenter?.didTapFavoriteButton()
        }
        contentView.onPullToRefreshr = { [weak self] in
            self?.presenter?.didPullToRefresh()
        }
        contentView.onImageTap = { [weak self] in
            self?.presenter?.onImageTap()
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupLoadingViewState() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupErrorViewState() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
