//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Arun Kumar on 9/13/21.
//

import UIKit
import os.log

// MARK: - NetworkManager
struct NetworkManager {
    static func fetchRestaurants<T>(with params: URLQueryConstructor,
                                    modelType: T.Type,
                                    completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        guard let url = params.url else {
            completion(.failure(.urlNotFound))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                os_log("Error encountered: %@", String(describing: error?.localizedDescription))
                if error.debugDescription.lowercased().contains("internet") {
                    completion(.failure(.internetOffline))
                } else {
                    completion(.failure(.cannotProcessData))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                os_log("Response not an HTTPURLResponse")
                completion(.failure(.cannotProcessData))
                return
            }
            
            guard HTTPHelper.isSuccess(httpResponse) else {
                os_log("Response contains error %@", httpResponse)
                completion(.failure(.cannotProcessData))
                return
            }
            
            guard let jsonData = data else {
                os_log("Nil Data object")
                completion(.failure(.cannotProcessData))
                return
            }
            
            do {
                let nearByRestaurants = try JSONDecoder().decode(modelType, from: jsonData)
                completion(.success(nearByRestaurants))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }.resume()
    }
}
