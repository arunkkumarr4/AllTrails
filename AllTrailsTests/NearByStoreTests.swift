//
//  NearByStoreTests.swift
//  NearByStoreTests
//
//  Created by Arun Kumar on 9/16/21.
//

import XCTest
import os.log
@testable import AllTrails

final class NearByStoreTests: XCTestCase {
    private lazy var nearbySearchResult: NearbyRestaurant? = {
        guard let path = Bundle(for: type(of: self)).path(forResource: "NearbyStores", ofType: "json") else {
            os_log("failed to load NearbyStores.json")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            let nearbyResult = try JSONDecoder().decode(NearbyRestaurant.self, from: jsonData)
            return nearbyResult
        }
        catch {
            os_log("failed to deserialize")
            return nil
        }
    }()

    func testResultCount() {
        XCTAssertNotNil(nearbySearchResult)
        XCTAssert(nearbySearchResult?.results.count ?? 0 > 0)        
    }
    
    func testResultNullablity() {
        nearbySearchResult?.results.forEach {
            XCTAssertNotNil($0.rating)
            XCTAssertNotNil($0.name)
            XCTAssertNotNil($0.placeId)
            XCTAssertNotNil($0.vicinity)
            XCTAssertNotNil($0.totalRating)
            XCTAssertNotNil($0.photos)
            XCTAssert($0.photos?.count ?? 0 > 0)
        }
    }
}
