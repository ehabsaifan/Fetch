//
//  RecipesViewModelTests.swift
//  Fetch RecipesTests
//
//  Created by Ehab Saifan on 12/5/24.
//

import XCTest
@testable import Fetch_Recipes

class RecipesViewModelTests: XCTestCase {
    func testGetDataSuccess() {
        let mockRecipesService = MockRecipesService(networkManager: MockNetworkManager())
        let mockImageCache = MockImageCacheService(
            networkManager: MockNetworkManager(),
            imageFileStorage: MockImageFileStorage()
        )
        let viewModel = RecipesViewModel(recipesService: mockRecipesService, imageCache: mockImageCache)

        let testRecipes = Recipes(recipes: [Recipe(name: "Test Recipe", cuisine: "", photoURLSmall: "test_url")])
        mockRecipesService.result = .success(testRecipes)

        let expectation = self.expectation(description: "Fetching recipes")

        viewModel.getData { error in
            XCTAssertNil(error)
            XCTAssertEqual(viewModel.data!, testRecipes)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetDataFailure() {
        let mockRecipesService = MockRecipesService(networkManager: MockNetworkManager())
        let mockImageCache = MockImageCacheService(
            networkManager: MockNetworkManager(),
            imageFileStorage: MockImageFileStorage()
        )
        let viewModel = RecipesViewModel(recipesService: mockRecipesService, imageCache: mockImageCache)

        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockRecipesService.result = .failure(testError)

        let expectation = self.expectation(description: "Fetching recipes with error")

        viewModel.getData { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error as NSError?, testError)
            XCTAssertNil(viewModel.data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetRecipeForRow() {
        let mockRecipesService = MockRecipesService(networkManager: MockNetworkManager())
        let mockImageCache = MockImageCacheService(
            networkManager: MockNetworkManager(),
            imageFileStorage: MockImageFileStorage()
        )
        let viewModel = RecipesViewModel(recipesService: mockRecipesService, imageCache: mockImageCache)

        let testRecipes = Recipes(recipes: [Recipe(name: "Test Recipe", cuisine: "", photoURLSmall: "test_url")])
        mockRecipesService.result = .success(testRecipes)

        let expectation = self.expectation(description: "Fetching recipes for testing row")

        viewModel.getData { error in
            XCTAssertNil(error)
            let recipe = viewModel.getRecipeFor(row: 0)
            XCTAssertEqual(recipe.name, "Test Recipe")
            XCTAssertEqual(recipe.photoURLSmall, "test_url")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
