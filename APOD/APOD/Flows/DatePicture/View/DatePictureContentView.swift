//
//  DatePictureContentView.swift
//  APOD
//
//  Created by Nata Kuznetsova on 26.08.2024.
//



import Foundation
import UIKit

class DatePictureContentView: UIView {
    
    //MARK: - Properties
    
    var onTapPresenterController: ((Bool) -> Void)?
    var onPullToRefreshr: (() -> Void)?
    var onImageTap: (() -> Void)?

    //MARK: - Private properties
    
    private var model: DataImage?
    private var starIsFilled: Bool = false
    
    private var labelTitleDate: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.text = "Select a date"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        //label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateLabel: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self,
                             action: #selector(datePickerAction(sender:)),
                             for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "starNormal"), for: .normal)
        //button.setImage(UIImage(systemName: "star"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private var addToFavoritesView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var labelDescriptions: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var scrollViewContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var starIsFilled: Bool = false

    //MARK: - Construction
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has nit been implemented")
    }
    
//    //MARK: - Life cycle  Наверно во ВьюКОНТРОЛЛЕР
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        presenter?.viewDidLoad()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupView()
//        setInitView()
//        presenter?.viewDidLoad()
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapGesture))
//        tapGesture.numberOfTapsRequired = 1
//        tapGesture.numberOfTouchesRequired = 1
//        imageView.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func viewTapGesture(gesture:UITapGestureRecognizer) {
//        guard let image = imageView.image else {
//            return
//        }
//        let imagePreviewScreen = ImagePreviewScreenBuilder.build(image: image)
//        imagePreviewScreen.modalPresentationStyle = .fullScreen
//        present(imagePreviewScreen, animated: false)
//    }

    //MARK: - Functions
    
    func setupViewWithModel(_ contentModel: DatePictureViewModel) {
        scrollView.refreshControl?.endRefreshing()
        starIsFilled = contentModel.isFavorite
        updateFavoriteButtonState()
        imageView.image = contentModel.image
        labelDescriptions.text = contentModel.description
    }
    
    @objc func datePickerAction(sender: UIDatePicker) {
        let selectedDate = dateFormatter.string(from: sender.date)
        
        networkController.fetchPhotoInfo(date: selectedDate) { [weak self] photoInfo in
            if let photoInfo = photoInfo {
                self?.updateUI(with: photoInfo)
            }
        }
    }
    
    @objc func didTapFavoriteButton() {
        toggleFavorite()
        onTapPresenterController?(starIsFilled)
    }
    
    @objc func didPullToRefresh() {
        onPullToRefreshr?()
    }
    
    @objc func didTapImage() {
        onImageTap?()
    }
    
    // ДОБАВИЛА ИЗ PictureOfDayContentView
    
//    func setupViewWithModel(_ contentModel: PictureOfDayViewModel) {
//        scrollView.refreshControl?.endRefreshing()
//        starIsFilled = contentModel.isFavorite
//        updateFavoriteButtonState()
//        imageView.image = contentModel.image
//        descriptionLabel.text = contentModel.description
//    }
//    
//    @objc func didTapFavoriteButton() {
//        toggleFavorite()
//        onTapPresenterController?(starIsFilled)
//    }
//    
//    @objc func didPullToRefresh() {
//        onPullToRefreshr?()
//    }
//    
//    @objc func didTapImage() {
//        onImageTap?()
//    }
    
    
    //MARK: - Private functions
    
     
        private func setupViews() {
            
            let imageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
            imageView.addGestureRecognizer(imageViewGestureRecognizer)
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
            scrollView.refreshControl = refreshControl
            
            button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
            
            stackView.addArrangedSubview(addToFavoritesView)
            stackView.addArrangedSubview(labelTitle)
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(labelDescriptions)
            stackView.addArrangedSubview(dateLabel)
            imageView.addSubview(addToFavoritesView)
            addToFavoritesView.addSubview(button)
            
            scrollViewContentView.addSubview(stackView)
            scrollView.addSubview(scrollViewContentView)
            addSubview(scrollView)
            
            setupConstraints()
        }
        
//
//        view.addSubview(labelTitleDate)
//        view.addSubview(dateLabel)
//        view.addSubview(button)
//        
//        stackView.addArrangedSubview(labelTitle)
//        stackView.addArrangedSubview(imageView)
//        stackView.addArrangedSubview(labelDescriptions)
//        
//        scrollViewContentView.addSubview(stackView)
//        scrollView.addSubview(scrollViewContentView)
//        view.addSubview(scrollView)
//        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
//        button.addGestureRecognizer(gestureRecognizer)
//        
//        setupConstraints()
//    }
//    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            
            scrollView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            scrollViewContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollViewContentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor),
            
            labelTitleDate.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            labelTitleDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            labelTitleDate.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            
//            button.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
//            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
//            button.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
//            button.widthAnchor.constraint(equalToConstant: 25),
//            button.heightAnchor.constraint(equalToConstant: 25),
            
            addToFavoritesView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            addToFavoritesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            addToFavoritesView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            addToFavoritesView.widthAnchor.constraint(equalToConstant: 25),
            addToFavoritesView.heightAnchor.constraint(equalToConstant: 25),
            
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            
            labelTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            labelTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor),
            
//            addToFavoritesView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),
//            
//            addToFavoritesView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
//            //addToFavoritesView.heightAnchor.constraint(equalToConstant: 50),
//            addToFavoritesView.widthAnchor.constraint(equalToConstant: 50),
//            
            
            labelDescriptions.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            labelDescriptions.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            button.topAnchor.constraint(equalTo: addToFavoritesView.topAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: addToFavoritesView.bottomAnchor, constant: -20),
            button.leadingAnchor.constraint(equalTo: addToFavoritesView.leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: addToFavoritesView.trailingAnchor, constant: 0),
            button.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    private func toggleFavorite() {
        self.starIsFilled = !starIsFilled
        updateFavoriteButtonState()
    }
    
    private func updateFavoriteButtonState() {
        //let starImageName = starIsFilled ? "star.fill": "star"
        //addToFavoriteButton.setImage(UIImage(systemName: starImageName), for: .normal)
        //addToFavoriteButton.backgroundColor = starIsFilled ? .systemGray4: .systemBlue
        //addToFavoriteButton.setTitle(starIsFilled ? "Remove from favorite": "Add to favorite", for: .normal)
        
        let starImageName = starIsFilled ? "starFavorite": "starNormal"
        button.setImage(UIImage(named: starImageName), for: .normal)

    }

//    private func setInitView() {
//        labelDescriptions.text = ""
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateLabel.maximumDate = .now
//    }
    
//    @objc func tap(){
//        print("Power")
//        if starIsFilled {
//            //button.setImage(UIImage(systemName: "star"), for: .normal)
//            button.setImage(UIImage(named: "starNormal"), for: .normal)
//            starIsFilled = false
//            presenter?.deleteFavorite(apod: model ?? DataImage())
//        }else{
//            //button.setImage(UIImage(systemName: "star.fill"), for: .normal)
//            button.setImage(UIImage(named: "starFavorite"), for: .normal)
//            starIsFilled = true
//            presenter?.addFavorite(apod: model ?? DataImage())
//        }
//    }
}

//extension DatePictureController: DatePicturePresenterDelegate {
//    
//    func updateUI(with photoinfo: DataImage){
//        networkController.fetchPhoto(from: photoinfo.url!) { [weak self] image in
//            DispatchQueue.main.async {
//                self?.imageView.image = image
//                self?.labelTitle.text = photoinfo.title
//                self?.labelDescriptions.text = photoinfo.explanation
//            }
//            self?.model = photoinfo
//            self?.model?.imageBinaryData = image?.pngData()
//        }
//        
//        starIsFilled = self.presenter?.checkFavoriteByDate(date: photoinfo.date ?? "") ?? false
//        DispatchQueue.main.async {
//            if self.starIsFilled {
//                //self.button.setImage(UIImage(systemName: "star.fill"), for: .normal)
//                self.button.setImage(UIImage(named: "starFavorite"), for: .normal)
//            }else{
//               // self.button.setImage(UIImage(systemName: "star"), for: .normal)
//                self.button.setImage(UIImage(named: "starNormal"), for: .normal)
//            }
//        }
//    }
    
//    func showAlert() {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: "Не удалось получить данные", message: "Данные актуальны", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    



