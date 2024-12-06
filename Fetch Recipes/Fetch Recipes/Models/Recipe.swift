//
//  Recipe.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import Foundation

struct Recipes: Codable, Equatable {
    let recipes: [Recipe]
    
    // Custom initializer for `Recipes`
    init(recipes: [Recipe]) {
        self.recipes = recipes
    }
}

struct Recipe: Codable {
    let uuid: String
    let name: String
    let cuisine: String
    
    let photoURLLarge: String?
    let photoURLSmall: String?
    let sourceURL: String?
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid, name, cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    // Custom initializer for `Recipe`
    init(uuid: String = "",
         name: String,
         cuisine: String,
         photoURLLarge: String? = nil,
         photoURLSmall: String? = nil,
         sourceURL: String? = nil,
         youtubeURL: String? = nil) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photoURLLarge = photoURLLarge
        self.photoURLSmall = photoURLSmall
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
