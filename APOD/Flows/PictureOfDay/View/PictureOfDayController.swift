//
//  ViewController.swift
//  APOD
//
//  Created by Nata Kuznetsova on 16.10.2023.
//

import UIKit

protocol PictureOfDayProtocol {
    func viewDidLoad()
    func didTapRetryButton()
    func addFavorite(apod: DataImage)
    func deleteFavorite(apod: DataImage)
}

class PictureOfDayController: UIViewController {
    
    //MARK: - Properties
    
    var presenter: PictureOfDayProtocol?
    
    //MARK: - Private properties
    
    private var model: DataImage?
    
    private var contentView: PictureOfDayContentView = {
        let view = PictureOfDayContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var loadingView: PictureOfDayLoadingView = {
        let view = PictureOfDayLoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var errorView: PictureOfDayErrorView = {
        let view = PictureOfDayErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Construction
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has nit been implemented")
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        presenter?.viewDidLoad()
    }
    
    //MARK: - Functions
    
    //MARK: - Private functions
    private func setupViews() {
        setupContentView()
        setupLoadingView()
        setupErrorView()
    }
    
    private func setupContentView(){
        view.addSubview(contentView)
        contentView.onTapPresenterController = onTapFromContentView(toggle:)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLoadingView(){
        view.addSubview(loadingView)
    
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupErrorView(){
        view.addSubview(errorView)
    
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }}
  
extension PictureOfDayController: PictureOfDayPresenterDelegate {
    
    func showLoaderState() {
        contentView.isHidden = true
        errorView.isHidden = true
        loadingView.isHidden = false
    }
    
    func showErorState() {
        contentView.isHidden = true
        loadingView.isHidden = true
        errorView.isHidden = false
    }
    
    func presentImage(apod: DataImage, data: Data, isFavorite: Bool){
        print("PresentImage")
        contentView.presentImage(apod: apod, data: data, isFilledStar: isFavorite)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.contentView.isHidden = false
            self.loadingView.isHidden = true
            self.errorView.isHidden = true
            }
        model = apod
    }
    
    func presentImageTwo(apod: DataImage, data: Data, isFavorite: Bool){
        contentView.presentImage(apod: apod, data: data, isFilledStar: isFavorite)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.contentView.isHidden = false
            self.errorView.isHidden = true
            }
        model = apod
    }
    
    func onTapFromContentView(toggle: Bool){
        print("Cache")
        if toggle {
            presenter?.addFavorite(apod: model ?? DataImage())
        }else{
            presenter?.deleteFavorite(apod: model ?? DataImage())
        }
    }
}
    
extension PictureOfDayController: PictureOfDayErrorViewDelegate {
    
    func didTapRetryButton() {
        presenter?.didTapRetryButton()
    }
}

