//
//  MapViewController.swift
//  MapViewController
//
//  Created by Arun Kumar on 9/14/21.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    private var allAnnotations: [MKAnnotation] = []
    
    private struct Constant {
        static let identifier = "Pin"
    }
    
    // MARK: - View controller's lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        
        mapView.selectedAnnotations.forEach({ mapView.deselectAnnotation($0, animated: true) })
        self.applyMapViewMemoryFix()
    }
    
    // MARK: - Injection pattern to configure mapview with stores
    func configure(with restaurants: [ViewModel.Restaurant]) {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if let fitToRegion = getGeoLocationBounds(stores: restaurants) {
            mapView.setRegion(fitToRegion, animated: false)
        }
        
        addPinsToMap(with: restaurants)
    }
    
    private func addPinsToMap(with restaurants: [ViewModel.Restaurant]) {
        mapView.removeAnnotations(mapView.annotations)
        
        // if not store found show the alert and return
        guard restaurants.count != 0 else {
            let alert = UIAlertController(title: l10n.Alert.Stores.noStoresTitle, message: l10n.Alert.Stores.noStoresMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: l10n.General.okText, style: .default, handler: { action in
                // We can decide on custom actions on these buttons
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }

        restaurants.forEach { store in
            let location = CLLocationCoordinate2D(latitude: store.lat, longitude: store.long)
            loadPin(with: location, in: store)
        }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    /// Will be called for every annotation and add it into the map
    private func loadPin(with location: CLLocationCoordinate2D, in store: ViewModel.Restaurant) {
        let storeLocationAnnotation = StoreLocationAnnotation(coordinate: location)
        storeLocationAnnotation.configure(with: store)
        mapView.addAnnotation(storeLocationAnnotation)
    }
    
    func getGeoLocationBounds(stores: [ViewModel.Restaurant]) -> MKCoordinateRegion? {
        let storeLatitudes = stores.map({$0.lat})
        let storeLongitudes = stores.map({$0.long})
        guard let latitudeMax = storeLatitudes.max(), let latitudeMin = storeLatitudes.min(), let longitudeMax = storeLongitudes.max(), let longitudeMin = storeLongitudes.min() else {
            return nil
        }
        let latitudeDelta = CLLocationDegrees(floatLiteral: latitudeMax - latitudeMin)
        let longitudeDelta = CLLocationDegrees(floatLiteral: longitudeMax - longitudeMin)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let center = CLLocationCoordinate2D(latitude: (latitudeMax + latitudeMin)/2.0, longitude: (longitudeMax + longitudeMin)/2.0)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    // MARK: - Memory cleaner
    // Map view consumes memory this is just a safeguard
    func applyMapViewMemoryFix() {
        mapView.delegate = nil
        mapView.removeAnnotations(mapView.annotations)
        mapView.overlays.forEach({ mapView.removeOverlay($0) })
        URLCache.shared.removeAllCachedResponses()
    }
    
    private func showNoLocationPermissionAlert() {
        let alert = UIAlertController(title: l10n.Alert.Permissions.locationRequestTitle, message: l10n.Alert.Permissions.locationRequestMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: l10n.General.enableText, style: .default, handler: { action in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: l10n.General.cancelText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
}

// MARK: - MapViewController
extension MapViewController {
    static func initializeViewController() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "mapView") as? MapViewController else { fatalError("Could not find controller") }
        return controller
    }
}


// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let userLocationView = mapView.view(for: mapView.userLocation) {
            userLocationView.isEnabled = false
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let userLocationView = annotation as? MKUserLocation {
            userLocationView.title = ""
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constant.identifier)
        
        if annotationView == nil {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: Constant.identifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "deselectedImage")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation?.isKind(of: MKUserLocation.self) != true else { return }

        // Configure customCallView
        guard let storeLocationAnnotation = view.annotation as? StoreLocationAnnotation else { return }

        configureCalloutView(in: view, with: storeLocationAnnotation)

        guard let annotation = view.annotation else { return }

        let annotationCoordinate = CLLocationCoordinate2D(
            latitude: annotation.coordinate.latitude,
            longitude: annotation.coordinate.longitude
        )

        mapView.setCenter(annotationCoordinate, animated: true)
        view.image = UIImage(named: "selectedImage")
        view.layer.zPosition = 1000.0
    }
    
    /// Initialize the CustomCallOutView
    /// Performs the injection of the data
    /// Set the bounds
    private func configureCalloutView(in view: MKAnnotationView, with storeLocationAnnotation: StoreLocationAnnotation) {
        if let calloutView = CustomCallOut.instanceFromNib() {
            calloutView.configure(in: view, with: storeLocationAnnotation)

            let width = UIScreen.main.bounds.width/1.10
            let dynamicHeight = calloutView.getMainStackViewHeight(newWidth: width)
            calloutView.frame = CGRect(x: 0, y: 0, width: width, height: dynamicHeight)
            calloutView.center = CGPoint(x: view.bounds.width / 2, y: -view.bounds.height-calloutView.bounds.height/3.0)
            calloutView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(calloutView)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self) {
            view.subviews.forEach { view in
                view.removeFromSuperview()
            }
        }
        
        view.image =  UIImage(named: "deselectedImage")
    }
}
