//
//  RecipeTableViewCell.swift
//  RecipiesAppAssignment
//
//  Created by Neha Kukreja on 05/10/24.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {

    var recipe: Recipes!
    var saveFavourites: (() -> Void)?
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var roundedCornerView: UIView!
    @IBOutlet weak var mealType: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBAction func favoriteBtnAction(_ sender: UIButton) {
        saveFavourites?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.favoriteBtn.setImage(UIImage(systemName: "suit.heart"), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeName.font = UIFont.boldSystemFont(ofSize: 20)
        favoriteBtn.tintColor = UIColor.red
        favoriteBtn.backgroundColor = UIColor.white
        favoriteBtn.layer.cornerRadius = 12
        self.selectionStyle = .none
        roundedCornerView.layer.cornerRadius = 12
        roundedCornerView.layer.borderWidth = 0.5
        roundedCornerView.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        recipeImageView.layer.cornerRadius = 12
        roundedCornerView.layer.shadowColor = UIColor.black.cgColor
        roundedCornerView.layer.shadowOpacity = 0.3
        roundedCornerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        roundedCornerView.layer.shadowRadius = 4
        roundedCornerView.layer.masksToBounds = false
    }
    
    func updateFavoriteButton(isFavorited: Bool) {
        let heartImage = isFavorited ? UIImage(systemName: "suit.heart.fill") : UIImage(systemName: "suit.heart")
        favoriteBtn.setImage(heartImage, for: .normal)
    }
    
    func configure(with recipe: Recipes) {
        updateFavoriteButton(isFavorited: recipe.isFavorited)
        self.recipe = recipe
        if let imageUrl = URL(string: recipe.image ?? "") {
            recipeImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImg"), options: [.continueInBackground, .progressiveLoad])
        }
        recipeName.text = recipe.name
        let mealTypes: [MealType] = recipe.mealType ?? []
        mealType.text = mealTypes.map { $0.rawValue }.joined(separator: ", ")
    }
}
