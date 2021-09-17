//
//  URLQueryConstructor.swift
//  URLQueryConstructor
//
//  Created by Arun Kumar on 9/16/21.
//

import Foundation

struct URLQueryConstructor {
    private let developmentKey: String = "AIzaSyDQSd210wKX_7cz9MELkxhaEOUhFP0AkSk"
    private let type: String = "restaurant"
    private let radius: Int = 1500
    private let lat, long: Double?
    private let requestType: RequestType
    private let keyword: String?
    private let photoRef: String?
        
    init(lat: Double? = nil,
         long: Double? = nil,
         photoRef: String? = nil,
         keyword: String? = nil,
         requestType: RequestType) {
        self.photoRef = photoRef
        self.long = long
        self.lat = lat
        self.requestType = requestType
        self.keyword = keyword
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "maps.googleapis.com"
        
        switch requestType {
        case .nearby:
            guard let long = long, let lat = lat else { return nil }
            components.path = "/maps/api/place/nearbysearch/json"
            components.queryItems = [
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "type", value: type),
                URLQueryItem(name: "location", value: "\(lat),\(long)")]
        case .searchedPlace:
            guard let term = keyword else { return nil }
            components.path = "/maps/api/place/findplacefromtext/json"
            components.queryItems = [
                URLQueryItem(name: "fields", value: "icon,name,place_id,price_level,rating,user_ratings_total,formatted_address,photos,geometry"),
                URLQueryItem(name: "input", value: term),
                URLQueryItem(name: "inputtype", value: "textquery")]
        case .photo:
            guard let ref = photoRef else { return nil }
            components.path = "/maps/api/place/photo"
            components.queryItems = [
                URLQueryItem(name: "maxwidth", value: "400"),
                URLQueryItem(name: "maxheight", value: "100"),
                URLQueryItem(name: "photo_reference", value: ref)]
        }
                
        components.queryItems?.append(URLQueryItem(name: "key", value: developmentKey))
        return components.url
    }
    
    enum RequestType {
        case nearby, searchedPlace, photo
    }
}
