//
//  RestaurantTableViewCell.swift
//  RestaurantTableViewCell
//
//  Created by Arun Kumar on 9/14/21.
//

import UIKit

/// Custom Restaurant cell
final class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var ratingStar1: UIImageView!
    @IBOutlet private var ratingStar2: UIImageView!
    @IBOutlet private var ratingStar3: UIImageView!
    @IBOutlet private var ratingStar4: UIImageView!
    @IBOutlet private var ratingStar5: UIImageView!
    @IBOutlet private var totalReviews: UILabel!
    @IBOutlet private var subText: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    private var restaurant: ViewModel.Restaurant?
    private weak var delegate: FavoriteDelegate?
    @IBOutlet private var restaurantIcon: UIImageView! {
        didSet {
            restaurantIcon.layer.cornerRadius = 10
            restaurantIcon.layer.borderWidth = 1.0
            restaurantIcon.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // Configure func with view model and delegate
    func configure(with restaurant: ViewModel.Restaurant, delegate: FavoriteDelegate) {
        // Assign to local values
        self.delegate = delegate
        self.restaurant = restaurant
        
        // Customize view with roundness
        ViewRounding.customizeView(for: contentView)
        
        // Setup the store title and total reviews
        name.text = restaurant.name
        totalReviews.text = "(\(restaurant.totalReviews))"
        
        // Fetch the image by url and set up store image
        if let url = restaurant.image {
            ImageHelper.fetchImage(from: url) { [weak self] (image) in
                guard let self = self else { return }
                self.restaurantIcon.image = image
            }
        }
        
        // Dynamically construct the sub text with price levels and desc
        var priceLevelString: String = ""
        for _ in 0..<restaurant.priceLevel { priceLevelString += "$" }
        subText.text = "\(priceLevelString) . \(restaurant.subText)"
        
        // Setup the favorite image depending on if it's already favorite or not
        let favButtonImage: String
        if restaurant.isFavorite == true {
            favButtonImage = "suit.heart.fill"
            favoriteButton.tintColor = .red
        } else {
            favButtonImage = "suit.heart"
            favoriteButton.tintColor = .lightGray
        }
        favoriteButton.setImage(UIImage(systemName: favButtonImage), for: .normal)
        
        // Setting up star image and tint
        [ratingStar1, ratingStar2, ratingStar3, ratingStar4, ratingStar5].forEach {
            $0?.image = UIImage(systemName: "star")
            $0?.tintColor = .lightGray
        }
         
        // Setting up the review stars depending on the value
        ReviewStarsHelper.setUpReviewStars(for: restaurant.rating,
                                              ratingStar1: ratingStar1,
                                              ratingStar2: ratingStar2,
                                              ratingStar3: ratingStar3,
                                              ratingStar4: ratingStar4,
                                              ratingStar5: ratingStar5)
    }
    
    
    // Action when favorite `heart` is pressed
    @IBAction func favoritePressed(_ sender: Any) {
        // Setup the image and tint when favorite is pressed
        favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        favoriteButton.tintColor = .red
        
        // Check the store if available
        // Mark it as favorite in file system
        // Send the callback to controller
        guard let store = restaurant else { return }
        StoreLocator.makeFavorite(with: store)
        delegate?.favoritePressed(restaurant: store)
    }
}

// MARK: - FavoriteDelegate
protocol FavoriteDelegate: AnyObject {
    func favoritePressed(restaurant: ViewModel.Restaurant)
}
