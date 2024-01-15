//
//  FavoritesToCollectionViewController.swift
//  APOD
//
//  Created by Irina on 05.01.2024.
//

import UIKit

//class FavoritesToCollectionViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .red
//    }
//    
//}
//    
protocol FavoriteToCollectionPresenterProtocol: AnyObject {}

class FavoriteToCollectionViewController: UIViewController {
    
    //MARK: - Properties
    
    var presenter: FavoriteToCollectionPresenterProtocol?
    
    //MARK: - Private properties
    
    //MARK: - Construction
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
        view.backgroundColor = .red
    }
}

