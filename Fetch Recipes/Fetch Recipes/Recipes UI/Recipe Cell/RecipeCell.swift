//
//  RecipeCell.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/3/24.
//

import UIKit

protocol RecipeCellDelegate: AnyObject {
    func watchVideo(recipe: Recipe)
}

class RecipeCell: UITableViewCell {
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var cuisineNameLabel: UILabel!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    weak var delegate: RecipeCellDelegate?
    
    private(set) var recipe: Recipe?
    private var imageCache: ImageCacheService?
    
    func setup(recipe: Recipe, imageCache: ImageCacheService, delegate: RecipeCellDelegate) {
        self.delegate = delegate
        self.recipe = recipe
        self.imageCache = imageCache
        
        let isActive = recipe.youtubeURL != nil
        button.alpha = isActive ? 1 : 0.6
        
        cuisineNameLabel.text = recipe.cuisine
        recipeNameLabel.text = recipe.name
        recipeImageView.tintColor = UIColor.black
        recipeImageView.image = UIImage.defaultCuisine
        loadImage(recipe: recipe)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.makeRoundEdges(radius: 8)
        recipeImageView.makeRoundEdges(radius: 8)
    }
    
    private func loadImage(recipe: Recipe) {
        guard let url = recipe.photoURLSmall else {
            return
        }
        imageCache?.getImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                if self?.recipe?.photoURLSmall == url {
                    self?.recipeImageView.image = image
                } else {
                    self?.recipeImageView.image = UIImage.defaultCuisine
                }
            case .failure:
                self?.recipeImageView.image = UIImage.defaultCuisine
            }
        }
    }
    
    @IBAction func watchNowPressed() {
        guard let recipe else {
            return
        }
        delegate?.watchVideo(recipe: recipe)
    }
}
