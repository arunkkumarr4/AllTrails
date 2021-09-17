//
//  ListTableViewController.swift
//  ListTableViewController
//
//  Created by Arun Kumar on 9/14/21.
//

import UIKit

final class ListTableViewController: UITableViewController {
    private var restaurants: [ViewModel.Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - configure
    // Injection pattern to initialize with Restaurant collection
    func configure(with restaurants: [ViewModel.Restaurant]) {
        self.restaurants = restaurants
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? RestaurantTableViewCell {
            if restaurants.count > indexPath.row {
                cell.configure(with: restaurants[indexPath.row], delegate: self)
            }
            return cell
        }

        return UITableViewCell()
    }
}

// MARK: - ListTableViewController
extension ListTableViewController: FavoriteDelegate {
    static func initializeViewController() -> ListTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "listview") as? ListTableViewController else { fatalError("Could not find controller") }
        return controller
    }
    
    // MARK: - FavoriteDelegate
    /// Iterate through the list to update and replace favorited store with isFavorite `true`
    func favoritePressed(restaurant: ViewModel.Restaurant) {
        if let row = restaurants.firstIndex(where: {$0.id == restaurant.id}) {
            restaurants[row] = ViewModel.Restaurant(image: restaurant.image, name: restaurant.name, subText: restaurant.subText, rating: restaurant.rating, priceLevel: restaurant.priceLevel, totalReviews: restaurant.totalReviews, isFavorite: true, id: restaurant.id, lat: restaurant.lat, long: restaurant.long)
        }
    }
}
