//
//  RecipesDetailViewController.swift
//  RecipieApp
//
//  Created by Neha Kukreja on 05/10/24.
//

import UIKit
import SDWebImage

class RecipesDetailViewController: UIViewController {
    
    // MARK: - PROPERTIES
    var recipe: Recipes?
    var saveFavourites: (() -> Void)?
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var recipeMajorContainerView: UIView!
    @IBOutlet weak var ingredientsListLbl: UILabel!
    @IBOutlet weak var recipeMajorDetailsView: UIView!
    @IBOutlet weak var difficultyLevel: UILabel!
    @IBOutlet weak var cookingTime: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeNameView: UIView!
    @IBOutlet weak var recipeImgView: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK: - IBACTIONS
    @IBAction func tapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favouriteBtnAction(_ sender: UIButton) {
        saveFavourites?()
        recipe?.isFavorited.toggle()
        updateFavoriteButton(isFavorited: recipe?.isFavorited ?? false)
    }
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupLabels()
        setupColors()
        setupFavouriteBtn()
        setupLayouts()
        addShadows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - PRIVATE METHODS
private extension RecipesDetailViewController {
    
    func setupLayouts() {
        backBtn.layer.cornerRadius = 12
        favoriteBtn.layer.cornerRadius = 12
        recipeNameView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        recipeMajorDetailsView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
        recipeMajorContainerView.layer.cornerRadius = 12
        recipeMajorDetailsView.layer.cornerRadius = 12
        recipeMajorDetailsView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        recipeMajorDetailsView.clipsToBounds = true
    }
    
    func addShadows() {
        recipeMajorContainerView.layer.shadowColor = UIColor.black.cgColor
        recipeMajorContainerView.layer.shadowOpacity = 0.3
        recipeMajorContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        recipeMajorContainerView.layer.shadowRadius = 4
        recipeMajorContainerView.layer.masksToBounds = false
    }
    
    func setupFavouriteBtn() {
        favoriteBtn.tintColor = UIColor.red
        favoriteBtn.backgroundColor = UIColor.white
        let heartImage = recipe?.isFavorited ?? false ? UIImage(systemName: "suit.heart.fill") : UIImage(systemName: "suit.heart")
        favoriteBtn.setImage(heartImage, for: .normal)
    }
    
    func setupColors() {
        recipeNameView.backgroundColor = UIColor(red: 255/255, green: 195/255, blue: 59/255, alpha: 1)
    }
    
    func setupLabels() {
        if let recipeRating = recipe?.rating {
            ratingLbl.text = "\(recipeRating)"
        }
        if let recipeCookingTime = recipe?.cookTimeMinutes {
            cookingTime.text = "\(recipeCookingTime)"
        }
        difficultyLevel.text = recipe?.difficulty
        recipeName.text = recipe?.name
        recipeName.textColor = UIColor.white
        if let imageUrl = URL(string: recipe?.image ?? "") {
            recipeImgView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [.continueInBackground, .progressiveLoad])
        }
        recipeName.font = UIFont.boldSystemFont(ofSize: 27)
        ingredientsListLbl.text = recipe?.ingredients?.joined(separator: ", ")
        ingredientsLbl.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func updateFavoriteButton(isFavorited: Bool) {
        let heartImage = isFavorited ? UIImage(systemName: "suit.heart.fill") : UIImage(systemName: "suit.heart")
        favoriteBtn.setImage(heartImage, for: .normal)
    }
}
