//
//  MockNetworkManager.swift
//  Fetch RecipesTests
//
//  Created by Ehab Saifan on 12/5/24.
//

import XCTest
@testable import Fetch_Recipes

class MockNetworkManager: DataTaskDownloadable, ImageDownloadable {
    var shouldReturnError = false
    var responseData: Data?
    var responseImage: UIImage?

    func execute<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(FetchError.noData))
        } else if let data = responseData {
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(FetchError.noData))
        }
    }

    func downloadImage(request: URLRequest, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID {
        if shouldReturnError {
            completion(.failure(FetchError.noData))
        } else if let image = responseImage {
            completion(.success(image))
        } else {
            completion(.failure(FetchError.noData))
        }
        return UUID()
    }

    func cancelTask(id: UUID) {
        // Mock cancellation logic
    }
}
