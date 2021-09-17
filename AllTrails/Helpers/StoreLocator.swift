//
//  StoreLocator.swift
//  StoreLocator
//
//  Created by Arun Kumar on 9/14/21.
//

import Foundation
import MapKit

// MATK: - StoreLocator
final class StoreLocator: LocationDelegate {
    static let favoriteStoreFileName = "favoriteStore"
    private lazy var locationManager = LocationHandler(delegate: self)
    weak var delegate: ReceivedLocation?
    
    func locationPermission() {
        // Location authorization
        locationManager.locationAuthorization()
    }
    
    func receivedLocation(_ location: CLLocation) {
        delegate?.receivedUserLocation(location)
    }
    
    
    static func makeFavorite(with viewModel: ViewModel.Restaurant) {
        var favoriteStores: [ViewModel.Restaurant] = ViewModel.getFavorites()
        
        guard favoriteStores.contains(viewModel) == false else { return }
        
        favoriteStores.append(ViewModel.Restaurant(image: viewModel.image, name: viewModel.name, subText: viewModel.subText, rating: viewModel.rating, priceLevel: viewModel.priceLevel, totalReviews: viewModel.totalReviews, isFavorite: true, id: viewModel.id, lat: viewModel.lat, long: viewModel.long))
        CodableFileStore.persist(encodableObject: favoriteStores, fileName: StoreLocator.favoriteStoreFileName)
    }
}

// MARK: - ReceivedLocation
protocol ReceivedLocation: AnyObject {
    func receivedUserLocation(_ location: CLLocation)
}
