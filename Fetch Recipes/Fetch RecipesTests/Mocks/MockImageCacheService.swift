//
//  MockImageCacheService.swift
//  Fetch RecipesTests
//
//  Created by Ehab Saifan on 12/5/24.
//

import XCTest
@testable import Fetch_Recipes

class MockImageCacheService: ImageCacheService {
    var mockImage: UIImage?
    var fetchError: Error?

    override func getImage(url urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let mockImage = mockImage {
            completion(.success(mockImage))
        } else if let fetchError = fetchError {
            completion(.failure(fetchError))
        }
    }
}
