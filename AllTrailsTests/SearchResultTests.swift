//
//  SearchResultTests.swift
//  SearchResultTests
//
//  Created by Arun Kumar on 9/16/21.
//

import XCTest
import os.log
@testable import AllTrails

final class SearchResultTests: XCTestCase {
    private lazy var searchResult: SearchedRestaurantResult? = {
        guard let path = Bundle(for: type(of: self)).path(forResource: "SearchedResult", ofType: "json") else {
            os_log("failed to load SearchResult.json")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            let searchResult = try JSONDecoder().decode(SearchedRestaurantResult.self, from: jsonData)
            return searchResult
        }
        catch {
            os_log("failed to deserialize")
            return nil
        }
    }()

    func testResultCount() {
        XCTAssertNotNil(searchResult)
        XCTAssert(searchResult?.candidates.count ?? 0 > 0)
    }
    
    func testResultNullablity() {
        searchResult?.candidates.forEach {
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
