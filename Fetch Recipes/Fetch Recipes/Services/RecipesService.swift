//
//  RecipesService.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import Foundation

class RecipesService {
    let networkManager: DataTaskDownloadable
    
    init(networkManager: DataTaskDownloadable) {
        self.networkManager = networkManager
    }
    
    func getRecipest(completion: @escaping (Result<Recipes, Error>)-> Void) {
        let url = URL(string: NetworkManager.baseURL + NetworkManager.FetchPath.recipes.rawValue)!
        let request = URLRequest(url: url)
        networkManager.execute(request: request) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
