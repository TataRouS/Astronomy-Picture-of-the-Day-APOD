//
//  NetworkServiece.swift
//  APOD
//
//  Created by Nata Kuznetsova on 25.10.2023.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func requestData(completion: @escaping (Result<DataImage, Error>) -> Void) -> Void
    func fetchPhotoInfo(date: String, completion: @escaping (DataImage?) -> Void)
    func fetchPhoto(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    enum NetworkError: Error {
        case dataError
        case urlCorrupt
    }
    
    // MARK: - Private properties

    private struct Constants {
        static let serviceBaseURLString = "https://api.nasa.gov/planetary/apod"
        static let apiKeyURLPartitionString = "?api_key="
        static let apiKey = "2YS2Stqx8sBjzjCbCbiRnaSielwhKXpiEgootxHg"
    }

    //MARK: - Functions
    
    func requestData() async throws -> DataImage {
        guard let url = URL(string: Constants.serviceBaseURLString + Constants.apiKeyURLPartitionString + Constants.apiKey) else {
            throw NetworkError.urlCorrupt
        }
        
        // Fetch JSON data
        let (data, _) = try await URLSession.shared.data(from: url)
        // Parse the JSON data
        let apodModel = try JSONDecoder().decode(DataImage.self, from: data)
        return apodModel
      }
    
  func requestData(completion: @escaping (Result<DataImage, Error>) -> Void ) {
      guard let url = URL(string: Constants.serviceBaseURLString + Constants.apiKeyURLPartitionString + Constants.apiKey) else {
          completion(.failure(NetworkError.urlCorrupt))
          return
      }
        
      URLSession.shared.dataTask(with: url) { (data, response,error) in
            guard let data = data else {
                completion(.failure(NetworkError.dataError))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let apod = try
                JSONDecoder().decode(DataImage.self, from: data)
                completion(.success(apod))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchPhotoInfo(date: String, completion: @escaping (DataImage?) -> Void) {
        let baseUrl = URL(string: Constants.serviceBaseURLString)
        let query: [String: String] = [
            "api_key": Constants.apiKey,
            "date": date
        ]
        guard let queryUrl = baseUrl?.withQueries(query) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: queryUrl) { data, _, _ in
            guard let data = data,
                  let photoInfoObject = try? JSONDecoder().decode(DataImage.self, from: data) else {
                completion(nil)
                return
            }
            completion(photoInfoObject)
        }.resume()
    }
    
    func fetchPhoto(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
