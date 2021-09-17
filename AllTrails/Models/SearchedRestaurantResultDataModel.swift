//
//  SearchedRestaurantResultDataModel.swift
//  SearchedRestaurantResultDataModel
//
//  Created by Arun Kumar on 9/16/21.
//

import Foundation

// MARK: - SearchedRestaurantResult
struct SearchedRestaurantResult: Codable {
    let candidates: [Restaurant]
    
    struct Restaurant: Codable {
        let icon, name, placeId, vicinity: String?
        let rating: Float?
        let priceLevel, totalRating: Int?
        let photos: [NearbyRestaurantResult.Photos]?
        let geometry: NearbyRestaurantResult.Geometry?
        
        private enum CodingKeys: String, CodingKey {
            case icon, name
            case placeId = "place_id"
            case priceLevel = "price_level"
            case rating
            case totalRating = "user_ratings_total"
            case vicinity = "formatted_address"
            case photos, geometry
        }
    }
}
