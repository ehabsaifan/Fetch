//
//  Fetch_RecipesTests.swift
//  Fetch RecipesTests
//
//  Created by Ehab Saifan on 12/5/24.
//

import XCTest
@testable import Fetch_Recipes

class RecipesServiceTests: XCTestCase {
    func testGetRecipesSuccess() {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.responseData = """
        {
            "recipes": [
                { "name": "Pizza", "cuisine": "Italian", "uuid": ""},
                { "name": "Sushi", "cuisine": "Japanese", "uuid": ""}
            ]
        }
        """.data(using: .utf8)
        
        let recipesService = RecipesService(networkManager: mockNetworkManager)
        let expectation = self.expectation(description: "Fetching recipes")
        
        recipesService.getRecipest { result in
            switch result {
            case .success(let recipes):
                XCTAssertEqual(recipes.recipes.count, 2)
                XCTAssertEqual(recipes.recipes.first?.name, "Pizza")
                XCTAssertNotNil(recipes.recipes.first?.uuid)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetRecipesFailure() {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.shouldReturnError = true
        
        let recipesService = RecipesService(networkManager: mockNetworkManager)
        let expectation = self.expectation(description: "Fetching recipes fails")
        
        recipesService.getRecipest { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error as? FetchError, FetchError.noData)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
