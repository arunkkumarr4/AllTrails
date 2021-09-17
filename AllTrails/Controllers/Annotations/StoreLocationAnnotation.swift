//
//  StoreLocationAnnotation.swift
//  StoreLocationAnnotation
//
//  Created by Arun Kumar on 9/15/21.
//

import MapKit

/// Annotations for a point on the map corresponding to a store.
final class StoreLocationAnnotation: NSObject, MKAnnotation {
    /// Map location of the store described by these annotations.
    var coordinate: CLLocationCoordinate2D
    var heading: String!
    var rating: Float!
    var subText: String!
    var totalReviews: Int!
    var storeImage: URL?
    var priceLevel: Int!
    var restaurant: ViewModel.Restaurant?

    /// Creates a new store location annotation.
    /// - Parameter coordinate: The map coordinate of the store these annotations describe.
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    /// Configures the store annotation.
    /// - Parameter restaurant: View model for the store these annotations describe.
    func configure(with restaurant: ViewModel.Restaurant) {
        self.restaurant = restaurant
        self.heading = restaurant.name
        self.rating = restaurant.rating
        self.subText = restaurant.subText
        self.totalReviews = restaurant.totalReviews
        self.priceLevel = restaurant.priceLevel
        self.storeImage = restaurant.image
    }
}
