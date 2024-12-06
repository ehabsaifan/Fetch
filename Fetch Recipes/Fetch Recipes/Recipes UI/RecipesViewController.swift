//
//  RecipesViewController.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import UIKit
import SafariServices

class RecipesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()

    private var viewModel: RecipesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        setupIndicator()
        loadRecipes()
    }
    
    private func setupIndicator() {
        // Configure the activity indicator
        activityIndicator.center = tableView.center
        activityIndicator.hidesWhenStopped = true
        tableView.backgroundView = activityIndicator
        
        // Configure the refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        loadRecipes(isRefreshing: true)
    }
    
    private func loadRecipes(isRefreshing: Bool = false) {
        activityIndicator.startAnimating()
        viewModel.getData { [weak self] error in
            self?.activityIndicator.stopAnimating()
            if isRefreshing {
                self?.refreshControl.endRefreshing()
            }
            self?.tableView.reloadData()
            guard let error else {
                return
            }
            self?.alert(error)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        var nib = UINib(nibName: RecipeCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RecipeCell.identifier)
        
        nib = UINib(nibName: NoDataTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: NoDataTableViewCell.identifier)
    }
    
    private func setupViewModel() {
        let recipeService = RecipesService(networkManager: appDelegate.networkManager)
        let imageService = ImageCacheService(networkManager: appDelegate.networkManager,
                                             imageFileStorage: appDelegate.imageStorageManager)
        viewModel = RecipesViewModel(recipesService: recipeService,
                                     imageCache: imageService)
    }
}

// MARK: - UITableViewDataSource
extension RecipesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.data?.recipes.count ?? 0
        switch section {
        case RecipesViewModel.Section.list.rawValue:
            return count
        default:
            return count == 0 ? 1 : 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case RecipesViewModel.Section.list.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
            let recipe = viewModel.getRecipeFor(row: indexPath.row)
            cell.setup(recipe: recipe, imageCache: viewModel.imageCache, delegate: self)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.identifier, for: indexPath) as! NoDataTableViewCell
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension RecipesViewController: UITableViewDelegate {
    
}

// MARK: - RecipeCellDelegate
extension RecipesViewController: RecipeCellDelegate {
    func watchVideo(recipe: Recipe) {
        guard let urlString = recipe.youtubeURL,
              let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
}
