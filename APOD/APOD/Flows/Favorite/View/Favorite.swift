//
//  FavoriteScreenViewController.swift
//  APOD
//
//  Created by Irina on 11.11.2023.
//

import Foundation
import UIKit

protocol FavoritePresenterProtocol: AnyObject {
    func fetchPictures() -> [DataImage]
    func deleteFavorite(date: String)
}

struct DataViewImage {
    var copyright, date, explanation: String?
    var data: Data
    var mediaType, serviceVersion, title: String?
    var url: URL?
}

class Favorite: UITableViewController {
    
    //MARK: - Properties
    
    var presenter: FavoritePresenterProtocol?
    
    
    //MARK: - Private properties
    
    // private var models: [DataImage] = []
    private var viewModels: [DataViewImage] = []
    
    //MARK: - Construction
    
    //    init() {
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has nit been implemented")
    //    }
    
    //MARK: - Life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       update()
    }
    
    override func viewDidLoad() {
        print("TableFavorite")
        super.viewDidLoad()
        update()
        title = "Favorite"
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "Cell")
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(update), for: .valueChanged)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let cell = cell as? FavoriteCell else {
            return UITableViewCell()
        }
        let model = viewModels[indexPath.row]
        print("tableVuewlload", model)
        cell.onTapPresenterController = onTapDeleteFavorite
        print("etupTextLabel", model)
        cell.setupTextLabel(apod: model)
        return cell
        
    }
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.beginUpdates()
//            models.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
//        }
//    }
    
    //MARK: - Functions
    
    @objc func update() {
        print("UpdateFunction", viewModels)
        let models = presenter?.fetchPictures() ?? []
        
        DispatchQueue.global ().async {
            var viewModels: [DataViewImage] = []
            for model in models {
                if let url = URL (string: model.hdurl ?? ""), let data = try?
                    Data(contentsOf: url)
                {
                    viewModels.append(DataViewImage( copyright: model.copyright, date: model.date, explanation: model.explanation, data: data, title: model.title))
                }
            }
            self.viewModels = viewModels
            self.updateView(viewModels: self.viewModels)
        }
        
    }
    
    //MARK: - Private functions
    
    private func onTapDeleteFavorite(date: String){
        print("Deletefrom3sreen", date)
        for viewModel in viewModels   {
            if viewModel.date == date {
                presenter?.deleteFavorite(date: viewModel.date ?? "")
                update()
            }
        }
    }
}

extension Favorite: FavoritePresenterDelegate {
    
    func updateView(viewModels: [DataViewImage]) {
        self.viewModels = viewModels
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func showError(error: Error, date: Date) {
        print("Error here: ", error)
    }
}

////
////  FavoriteScreenViewController.swift
////  APOD
////
////  Created by Irina on 11.11.2023.
////
//
//import Foundation
//import UIKit
//
//protocol FavoritePresenterProtocol: AnyObject {
//    func fetchPictures() -> [DataImage]
//    func deleteFavorite(apod: DataImage)
//}
//
//class Favorite: UITableViewController {
//    
//    //MARK: - Properties
//    
//    var presenter: FavoritePresenterProtocol?
//    
//    
//    //MARK: - Private properties
//    
//    private var models: [DataImage] = []
//    
//    //MARK: - Construction
//    
//    //    init() {
//    //        super.init(nibName: nil, bundle: nil)
//    //    }
//    //
//    //    required init?(coder: NSCoder) {
//    //        fatalError("init(coder:) has nit been implemented")
//    //    }
//    
//    //MARK: - Life cycle
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//      // update()
//    }
//    
//    override func viewDidLoad() {
//        print("TableFavorite")
//        super.viewDidLoad()
//        models =  presenter?.fetchPictures() ?? []
//        tableView.reloadData()
//        title = "Favorite"
//        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "Cell")
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(update), for: .valueChanged)
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        models.count
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        guard let cell = cell as? FavoriteCell else {
//            return UITableViewCell()
//        }
//        let model = models[indexPath.row]
//        
//        print("tableVuewlload", models)
//        cell.onTapPresenterController = onTapDeleteFavorite
//        DispatchQueue.global ().async {
//            if let url = URL (string: model.hdurl ?? ""), let data = try?
//                Data(contentsOf: url)
//            {
//                DispatchQueue.main.async {
//                    print("etupTextLabel", model)
//                    let picture =  UIImage(data: data)
//                    cell.setupTextLabel(apod: model, picture: ((picture ?? UIImage(systemName: "star"))!))
//                }
//            }
//        }
//        return cell
//        
//    }
//    
//    //MARK: - Functions
//    
//    @objc func update() {
//        print("UpdateFunction", models)
//        self.models = presenter?.fetchPictures() ?? []
//        updateView(apod: self.models)
//        
//    }
//    
//    //MARK: - Private functions
//    
//    private func onTapDeleteFavorite(date: String){
//        print("Deletefrom3sreen", date)
//        for model in models {
//            if model.date == date {
//                presenter?.deleteFavorite(apod: model)
//                update()
//            }
//        }
//    }
//}
//
//extension Favorite: FavoritePresenterDelegate {
//    func updateView(apod: [DataImage]) {
//        self.models = apod
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//        DispatchQueue.main.async {
//            self.refreshControl?.endRefreshing()
//        }
//    }
//    
//    func showError(error: Error, date: Date) {
//        print("Error here: ", error)
//    }
//}
//
//
