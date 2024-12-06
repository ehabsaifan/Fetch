//
//  RecipesViewModel.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/3/24.
//

import Foundation

class RecipesViewModel {
    private let recipesService: RecipesService
    let imageCache: ImageCacheService

    private(set) var data: Recipes?
    
    init(recipesService: RecipesService,
         imageCache: ImageCacheService) {
        self.recipesService = recipesService
        self.imageCache = imageCache
    }
    
    enum Section: Int, CaseIterable {
        case list, empty
    }
    
    func getData(completion: @escaping (Error?) -> Void) {
        recipesService.getRecipest { result in
            switch result {
            case .success(let data):
                self.data = data
                completion(nil)
            case .failure(let error):
                self.data = nil
                completion(error)
            }
        }
    }
}

extension RecipesViewModel {
    func getNumberOfSection() -> Int {
        return Section.allCases.count
    }
    
    func getRecipeFor(row: Int) -> Recipe {
        data!.recipes[row]
    }
}
