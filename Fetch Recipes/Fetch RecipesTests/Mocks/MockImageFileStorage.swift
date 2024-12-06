//
//  MockImageFileStorage.swift
//  Fetch RecipesTests
//
//  Created by Ehab Saifan on 12/5/24.
//

import UIKit
@testable import Fetch_Recipes

class MockImageFileStorage: ImageFileStorageP {
    func retrieveImage(named: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        completion(.failure(FetchError.noData)) // Simulate disk failure
    }

    func saveImage(_ image: UIImage, withName name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(())) // Simulate successful save
    }
}
