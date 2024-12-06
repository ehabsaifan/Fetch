//
//  ImageCacheServiceTests.swift
//  Fetch RecipesTests
//
//  Created by Ehab Saifan on 12/5/24.
//

import XCTest
@testable import Fetch_Recipes

class ImageCacheServiceTests: XCTestCase {
    func testGetImageFromMemoryCache() {
        let mockNetworkManager = MockNetworkManager()
        let mockFileStorage = MockImageFileStorage()
        let testCache = NSCache<NSURL, UIImage>() // Test-specific cache
        let cacheService = ImageCacheService(
            networkManager: mockNetworkManager,
            imageFileStorage: mockFileStorage,
            cache: testCache
        )
        
        let testURL = "https://example.com/image.png"
        let testImage = UIImage()
        testCache.setObject(testImage, forKey: NSURL(string: testURL)!)
        
        let expectation = self.expectation(description: "Fetching image from memory cache")
        
        cacheService.getImage(url: testURL) { result in
            switch result {
            case .success(let image):
                XCTAssertEqual(image, testImage)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetImageFromServer() {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.responseImage = UIImage()
        let mockFileStorage = MockImageFileStorage()
        let cacheService = ImageCacheService(
            networkManager: mockNetworkManager,
            imageFileStorage: mockFileStorage
        )
        
        let testURL = "https://example.com/image.png"
        
        let expectation = self.expectation(description: "Fetching image from server")
        
        cacheService.getImage(url: testURL) { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
