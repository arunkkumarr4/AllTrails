//
//  ViewModel.swift
//  ViewModel
//
//  Created by Arun Kumar on 9/13/21.
//

import Foundation

struct ViewModel {
    
    // MARK: - Restaurant
    struct Restaurant: Codable, Equatable {
        let image: URL?
        let name, subText: String
        let rating: Float
        let priceLevel, totalReviews: Int
        var isFavorite: Bool
        let id: String
        let lat, long: Double
        
        public static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
            lhs.id == rhs.id
        }
    }    
        
    /// Fetch NearBy store(s)
    /// Update the local copy
    /// Replace the result with favorites if any found
    static func fetchNearbyRestaurants(lat: Double = -90.2432, long: Double = 29.9802,
                                completion: @escaping (Result<[Restaurant], NetworkError>) -> Void) {
        NetworkManager.fetchRestaurants(with: URLQueryConstructor(lat: lat,
                                                                        long: long,
                                                                        requestType: .nearby),
                                                                        modelType: NearbyRestaurant.self) { response in
            
            DispatchQueue.main.async {
                switch response {
                case .success(let dataModel):
                    let viewModel = dataModel.results.map {
                        Restaurant(image: URLQueryConstructor(photoRef: $0.photos?.first?.photoRef, requestType: .photo).url,
                                   name: $0.name ?? "",
                                   subText: $0.vicinity ?? "",
                                   rating: $0.rating ?? 0,
                                   priceLevel: $0.priceLevel ?? 0,
                                   totalReviews: $0.totalRating ?? 0,
                                   isFavorite: false,
                                   id: $0.placeId ?? "",
                                   lat: $0.geometry?.location.lat ?? 0,
                                   long: $0.geometry?.location.lng ?? 0)
                    }
                    var favorites = ViewModel.getFavorites().filter{ item in viewModel.contains(item) }
                    let unfavorites = viewModel.filter{ item in !ViewModel.getFavorites().contains(item) }
                    favorites.append(contentsOf: unfavorites)
                    completion(.success(favorites))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Fetch searched store(s)
    /// Update the local copy
    /// Replace the result with favorites if any found
    static func fetchSearchedRestaurants(keyword: String = "Pakwan",
                                  completion: @escaping (Result<[Restaurant], NetworkError>) -> Void) {
        NetworkManager.fetchRestaurants(with: URLQueryConstructor(keyword: keyword,
                                                                    requestType: .searchedPlace),
                                                                    modelType: SearchedRestaurantResult.self) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let dataModel):                    
                    let viewModel = dataModel.candidates.map {
                        Restaurant(image: URLQueryConstructor(photoRef: $0.photos?.first?.photoRef, requestType: .photo).url,
                                   name: $0.name ?? "",
                                   subText: $0.vicinity ?? "",
                                   rating: $0.rating ?? 0,
                                   priceLevel: $0.priceLevel ?? 0,
                                   totalReviews: $0.totalRating ?? 0,
                                   isFavorite: false,
                                   id: $0.placeId ?? "",
                                   lat: $0.geometry?.location.lat ?? 0,
                                   long: $0.geometry?.location.lng ?? 0)
                    }
                    
                    var favorites = ViewModel.getFavorites().filter{ item in viewModel.contains(item) }
                    let unfavorites = viewModel.filter{ item in !ViewModel.getFavorites().contains(item) }
                    favorites.append(contentsOf: unfavorites)
                    completion(.success(favorites))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func getFavorites() -> [ViewModel.Restaurant] {
        do {
            if let favoriteStores: [ViewModel.Restaurant] = try CodableFileStore.read(fileName: StoreLocator.favoriteStoreFileName) {
                return favoriteStores
            }
            return []
        } catch {
            return []
        }
    }
}
