//
//  FileFavoriteCache.swift
//  APOD
//
//  Created by Nata Kuznetsova on 29.11.2023.
//

import Foundation
import CoreData

protocol DataStoreServiceProtocol {
    func addPictureToFavoriteIfNeeded(apod: DataImage)
    func getFavoritePictures() -> [DataImage]
    func isFavorite(date: String) -> Bool
    func deletePicture(date: String)
}

protocol DataStoreServiceDelegate: AnyObject {
    func didReceiveError(_ error: DataStoreServiceError)
}

enum DataStoreServiceError: Error {
    case unknownError(Error)
}

final class DataStoreService {
    
    private struct Constants {
        static let persistentContainerName = "APODDataModel"
        static let pictureModel = "PictureModelCD"
    }
    
    // MARK: - Properties
    
    weak var delegate: DataStoreServiceDelegate?
    
    // MARK: - Private properties
    
    private let persistentContainer = NSPersistentContainer(name: Constants.persistentContainerName)
    
    // MARK: - Construction
    
    init() {
        persistentContainer.loadPersistentStores(completionHandler: { [weak self] (_, error) in
            if let error = error {
                self?.delegate?.didReceiveError(.unknownError(error))
            }
        })
    }
    
    // MARK: - Private functions
    
    private func saveStateIfNeeded(){
        guard persistentContainer.viewContext.hasChanges else {
            return
        }
        do {
            try persistentContainer.viewContext.save()
        } catch {
            delegate?.didReceiveError(.unknownError(error))
        }
    }
    
    private func delete(object: NSManagedObject){
        persistentContainer.viewContext.delete(object)
        saveStateIfNeeded()
    }
    
    private func addPictureToFavorite(apod: DataImage) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.pictureModel)
        fetchRequest.predicate = NSPredicate(format: "date = %@", argumentArray: [apod.date ?? ""])
        let result = try? persistentContainer.viewContext.fetch(fetchRequest)
        guard result?.first == nil else {
            return
        }
        
        let apodModel = PictureModelCD(context: persistentContainer.viewContext)
        apodModel.title = apod.title
        apodModel.explanation = apod.explanation
        apodModel.picture = apod.hdurl
        apodModel.date = apod.date
        
        saveStateIfNeeded()
        print("Запись в базу", apodModel)
    }
    
    internal func deletePicture(date: String){
        let fetchRequest: NSFetchRequest<PictureModelCD> =
        PictureModelCD.fetchRequest()
     //   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureModelCD")
        fetchRequest.predicate = NSPredicate(format: "date = %@", argumentArray: [date ?? ""])
       guard let result = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            return
        }
        for object in result {
            delete(object:  object)
            saveStateIfNeeded()
        }
    }
}

extension DataStoreService: DataStoreServiceProtocol {
    func addPictureToFavoriteIfNeeded(apod: DataImage) {
        guard let date = apod.date, isFavorite(date: date) else {
            addPictureToFavorite(apod: apod)
            print("addPictureFunc addPictureToFavoriteIfNeeded", apod)
            return
        }
        print("DeletingPictureFunc addPictureToFavoriteIfNeeded", apod)
        deletePicture(date: date)
    }
    
    func getFavoritePictures() -> [DataImage] {
        let fetchRequest: NSFetchRequest<PictureModelCD> =
        PictureModelCD.fetchRequest()
        guard let apods = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            return []
        }
        print("fromDataBase", apods)
        var favoriteApods: [DataImage] = []
        for apod in apods {
            favoriteApods.append(DataImage (date: apod.date,
                                            explanation: apod.explanation,
                                            hdurl: apod.picture,
                                            title: apod.title))
        }
        print("Date favoriteApods:", favoriteApods)
        return favoriteApods
    }
    
    func isFavorite(date: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.pictureModel)
        fetchRequest.predicate = NSPredicate(format: "date = %@", argumentArray: [date])
        let result = try? persistentContainer.viewContext.fetch(fetchRequest)
        return result?.first != nil
    }
}
