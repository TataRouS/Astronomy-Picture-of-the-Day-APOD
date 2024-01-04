//
//  DataPictureViewController.swift
//  APOD
//
//  Created by Irina on 04.11.2023.
//

import UIKit

protocol DatePicturePresenterProtocol {
    func viewDidLoad()
    func addFavorite(apod: DataImage)
    func deleteFavorite(apod: DataImage)
    func checkFavoriteByDate(date: String) -> Bool
}

class DatePictureController: UIViewController {
    
    //MARK: - Properties
    
    var presenter: DatePicturePresenterProtocol?
    let networkController = NetworkService()
    let dateFormatter = DateFormatter()
    
    //MARK: - Private properties
    
    private var model: DataImage?
    private var starIsFilled: Bool = false
    
    private var labelTitleDate: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.text = "Выбери дату"
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
        button.setImage(UIImage(systemName: "star"), for: .normal)
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
    //MARK: - Construction
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has nit been implemented")
    }
    
    //MARK: - Life cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setInitView()
        presenter?.viewDidLoad()
    }
    
    //MARK: - Functions
    
    @objc func datePickerAction(sender: UIDatePicker) {
        let selectedDate = dateFormatter.string(from: sender.date)
        
        networkController.fetchPhotoInfo(date: selectedDate) { [weak self] photoInfo in
            if let photoInfo = photoInfo {
                self?.updateUI(with: photoInfo)
            }
        }
    }
    
    //MARK: - Private functions
    
    private func setupView() {
        
        view.addSubview(labelTitleDate)
        view.addSubview(dateLabel)
        view.addSubview(button)
        
        stackView.addArrangedSubview(labelTitle)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelDescriptions)
        
        scrollViewContentView.addSubview(stackView)
        scrollView.addSubview(scrollViewContentView)
        view.addSubview(scrollView)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        button.addGestureRecognizer(gestureRecognizer)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            labelTitleDate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelTitleDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            labelTitleDate.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            
            button.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            button.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            scrollView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            scrollViewContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollViewContentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor),
            
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            labelDescriptions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelDescriptions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    private func setInitView() {
        labelDescriptions.text = ""
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateLabel.maximumDate = .now
    }
    
    @objc func tap(){
        print("Power")
        if starIsFilled {
            button.setImage(UIImage(systemName: "star"), for: .normal)
            starIsFilled = false
            presenter?.deleteFavorite(apod: model ?? DataImage())
        }else{
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starIsFilled = true
            presenter?.addFavorite(apod: model ?? DataImage())
        }
    }
}

extension DatePictureController: DatePicturePresenterDelegate {
    
    func updateUI(with photoinfo: DataImage){
        networkController.fetchPhoto(from: photoinfo.url!) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.labelTitle.text = photoinfo.title
                self?.labelDescriptions.text = photoinfo.explanation
            }
            self?.model = photoinfo
        }
        starIsFilled = self.presenter?.checkFavoriteByDate(date: photoinfo.date ?? "") ?? false
        DispatchQueue.main.async {
            if self.starIsFilled {
                self.button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }else{
                self.button.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Не удалось получить данные", message: "Данные актуальны", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

