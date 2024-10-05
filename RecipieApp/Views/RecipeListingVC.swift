//
//  ViewController.swift
//  RecipiesAppAssignment
//
//  Created by Neha Kukreja on 05/10/24.
//

import UIKit

class RecipeListingVC: UIViewController {
    
    // MARK: - PROPERTIES
    let viewModel = RecipeViewModel()
    var activityIndicator: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()

    // MARK: - IBOUTLETS
    @IBOutlet weak var recipiesTableView: UITableView!
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
        setupRefreshControl()
        activityIndicator.startAnimating()
        viewModel.delegate = self
        viewModel.hitAPIToGetRecipies()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - PRIVATE METHODS
private extension RecipeListingVC {
    
    func setupTableView() {
        recipiesTableView.delegate = self
        recipiesTableView.dataSource = self
        recipiesTableView.separatorStyle = .none
        registerNib()
    }
    
    func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshRecipesData), for: .valueChanged)
        recipiesTableView.refreshControl = refreshControl
    }
    
    func registerNib() {
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        recipiesTableView.register(nib, forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        positionActivityIndicatorCenter()
    }
    
    func positionActivityIndicatorCenter() {
        activityIndicator.center = view.center
    }
    
    func positionActivityIndicatorBottom() {
        let bottomOffset = CGPoint(x: view.frame.size.width / 2, y: recipiesTableView.contentSize.height + 50)
        activityIndicator.center = bottomOffset
    }
    
    func handleActivityIndicator() {
        if viewModel.isLoading {
            if viewModel.currentPage == 1 {
                positionActivityIndicatorCenter()
            } else {
                positionActivityIndicatorBottom()
            }
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - OBJC METHODS
@objc extension RecipeListingVC {
    
    func refreshRecipesData() {
        viewModel.resetRecipes()
        viewModel.hitAPIToGetRecipies()
    }
}

// MARK: - TABLE VIEW DELEGATES & TABLE VIEW DATASOURCE
extension RecipeListingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let recipe = viewModel.recipes[indexPath.row]
        cell.configure(with: recipe)
        cell.saveFavourites = { [weak self] in
            guard let self = self else { return }
            self.viewModel.recipes[indexPath.row].isFavorited.toggle()
            self.viewModel.saveFavorites()
            self.recipiesTableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = viewModel.recipes[indexPath.row]
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "RecipesDetailViewController") as? RecipesDetailViewController {
            detailVC.saveFavourites = { [weak self] in
                guard let self = self else { return }
                self.viewModel.recipes[indexPath.row].isFavorited.toggle()
                self.viewModel.saveFavorites()
                self.recipiesTableView.reloadData()
            }
            detailVC.recipe = selectedRecipe
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height && !viewModel.isLoading {
            viewModel.hitAPIToGetRecipies()
        }
    }
}

// MARK: - RECIPIES PROTOCOL
extension RecipeListingVC: RecipiesProtocol {
    
    func updateTableData() {
        DispatchQueue.main.async {
            self.handleActivityIndicator()
            self.refreshControl.endRefreshing()
            self.recipiesTableView.reloadData()
        }
    }
    
    func displayError(_ error: Error) {
        print(error)
    }
}


