//
//  MockRecipesService.swift
//  Fetch RecipesTests
//
//  Created by Ehab Saifan on 12/5/24.
//

import XCTest
@testable import Fetch_Recipes

class MockRecipesService: RecipesService {
    var result: Result<Recipes, Error>?

    override func getRecipest(completion: @escaping (Result<Recipes, Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
