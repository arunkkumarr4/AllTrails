//
//  ViewController.swift
//  AllTrails
//
//  Created by Arun Kumar on 9/13/21.
//

import UIKit
import MapKit

final class ViewController: UIViewController, UISearchBarDelegate, ReceivedLocation {
    @IBOutlet private var switchViewButton: UIButton! {
        didSet {
            switchViewButton.layer.zPosition = 1
            switchViewButton.backgroundColor = .systemGreen.darker(by: 30)
            switchViewButton.layer.cornerRadius = 5
            switchViewButton.layer.borderWidth = 1
            switchViewButton.layer.borderColor = UIColor.systemGreen.darker(by: 30)?.cgColor
            switchViewButton.setTitleColor(.white, for: .normal)
            switchViewButton.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
            switchViewButton.tintColor = .white
            switchViewButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            switchViewButton.titleLabel?.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    private var mapViewController: MapViewController? = nil
    private var listViewController: ListTableViewController? = nil
    private var storeLocator: StoreLocator?
    private var screenType: ScreenType = .listView
    private var restaurants: [ViewModel.Restaurant] = []
    
    // MARK: - ViewController's lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeLocator = StoreLocator()
        storeLocator?.delegate = self
        assignViews()
        setupSearchBarUI()
        storeLocator?.locationPermission()
        view.bringSubviewToFront(switchViewButton)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchBar.endEditing(true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.endEditing(true)
    }
    
    deinit {
        mapViewController = nil
        listViewController = nil
    }
    
    // MARK: - ScreenType
    enum ScreenType {
        case listView, mapView
        
        /// func to toggle between the enums when called
        mutating func toggle() {
                switch self {
                    case .listView:
                        self = .mapView
                    case .mapView:
                        self = .listView
                }
            }
    }
    
    private func assignViews() {
        mapViewController = MapViewController.initializeViewController()
        listViewController = ListTableViewController.initializeViewController()
    }
    
    //Set the search bar place holder color to conform to accessibility contrast ratio
    private func setupSearchBarUI() {
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        if let searchBarTextfield = searchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextfield.backgroundColor = .white
            searchBarTextfield.textColor = .black
            searchBarTextfield.layer.borderColor = UIColor.systemGray.cgColor
            searchBarTextfield.layer.borderWidth = 1
            searchBarTextfield.layer.cornerRadius = 8
            searchBarTextfield.attributedPlaceholder = NSAttributedString(
                string: l10n.General.searchPlaceholder,
                attributes: [.foregroundColor: UIColor.gray]
            )
            
            if let searchImageView = searchBarTextfield.leftView as? UIImageView {
                searchImageView.image = searchImageView.image?.withRenderingMode(.alwaysTemplate)
                searchImageView.tintColor = .systemGray
            }
        }
    }

    // MARK: - IBAction switchViewPressed
    @IBAction func switchViewPressed(_ sender: Any) {
        screenType.toggle()
        switchControllers()
    }
    
    private func switchControllers() {
        switch screenType {
        case .listView:
            if let listController = listViewController {
                //add as a childViewController
                addChild(listController)

                 // Add the child's View as a subview
                 containerView.addSubview(listController.view)
                listController.view.frame = containerView.bounds
                listController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                 // tell the childViewController it's contained in it's parent
                listController.didMove(toParent: self)
            }
            self.listViewController?.configure(with: restaurants)
            self.listViewController?.tableView.reloadData()
        case .mapView:
            if let mapController = mapViewController {
                //add as a childViewController
                addChild(mapController)

                 // Add the child's View as a subview
                 containerView.addSubview(mapController.view)
                mapController.view.frame = containerView.bounds
                mapController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                 // tell the childViewController it's contained in it's parent
                mapController.didMove(toParent: self)
            }
            self.mapViewController?.configure(with: restaurants)
            self.mapViewController?.view.bringSubviewToFront(switchViewButton)
        }
        containerView.bringSubviewToFront(switchViewButton)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        // Get the text
        // Pass it to api to load store data
        guard let location = searchBar.text, location.isEmpty != true else {
            self.present(ErrorDialogHelper.presentNoLocationFoundAlert(), animated: true, completion: nil)
            return
        }
        
        Activity.showActivityIndicatory(view: view)
        ViewModel.fetchSearchedRestaurants(keyword: location) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                Activity.stopActivityIndicatory()
                switch result {
                case .success(let restaurants):
                    self.restaurants = restaurants
                    self.switchControllers()
                case .failure(let error):
                    if error == .internetOffline {
                        ErrorDialogHelper.displayNetworkFailureError(parent: self)
                    } else {
                        self.present(ErrorDialogHelper.presentNoLocationFoundAlert(), animated: true, completion: nil)
                    }
                }
            }
        }
        
        // Dismiss keyboard on search key
        searchBar.endEditing(true)
    }
    
    func receivedUserLocation(_ location: CLLocation) {
        ViewModel.fetchNearbyRestaurants(lat: location.coordinate.latitude, long: location.coordinate.longitude) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let restaurants):
                    self.restaurants = restaurants
                    self.switchControllers()
                case .failure(let error):
                    if error == .internetOffline {
                        ErrorDialogHelper.displayNetworkFailureError(parent: self)
                    } else {
                        self.present(ErrorDialogHelper.presentNoLocationFoundAlert(), animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

