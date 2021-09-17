//
//  NearbyRestaurantDataModel.swift
//  NearbyRestaurantDataModel
//
//  Created by Arun Kumar on 9/16/21.
//

import Foundation

// MARK: - NearbyRestaurant
struct NearbyRestaurant: Codable {
    let results: [NearbyRestaurantResult]
}

// MARK: - NearbyRestaurantResult
struct NearbyRestaurantResult: Codable {
    let icon, name, placeId, vicinity: String?
    let rating: Float?
    let priceLevel, totalRating: Int?
    let photos: [Photos]?
    let geometry: Geometry?
    
    struct Geometry: Codable {
        let location: Location
                
        struct Location: Codable {
            let lat: Double?
            let lng: Double?
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case icon, name
        case placeId = "place_id"
        case priceLevel = "price_level"
        case rating
        case totalRating = "user_ratings_total"
        case vicinity, photos, geometry
    }
    
    struct Photos: Codable {
        let photoRef: String?
        
        private enum CodingKeys: String, CodingKey {
            case photoRef = "photo_reference"
        }
    }
}
