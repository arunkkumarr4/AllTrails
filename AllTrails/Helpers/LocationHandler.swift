//
//  LocationHandler.swift
//  LocationHandler
//
//  Created by Arun Kumar on 9/14/21.
//

import UIKit
import CoreLocation
import os.log

// MARK: - LocationHandler
final class LocationHandler: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager = CLLocationManager()
    private weak var delegate: LocationDelegate?
    
    init(delegate: LocationDelegate?) {
        self.delegate = delegate
    }
    
    func locationAuthorization() {
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    // MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            guard CLLocationManager.locationServicesEnabled() else {
                os_log("Location service isn't available")
                return
            }
            
            locationManager.startUpdatingLocation()
        case .restricted, .denied: break
        @unknown default: break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isWaitValid(for: "LocationCallBack") == false else { return }
        if let loc = manager.location {
            setRetryTime(for: "LocationCallBack")
            delegate?.receivedLocation(loc)
        }
    }
    
    func isWaitValid(for type: String) -> Bool {
        guard let savedDate = UserDefaults.standard.object(forKey: type) as? Date else { return false }
        guard Date() < savedDate  else {
            UserDefaults.standard.removeObject(forKey: type)
            return false
        }
        
        return true
    }
    
    func setRetryTime(for type: String) {
        // Save 5 secs
        UserDefaults.standard.set(Calendar.current.date(byAdding: .second, value: 5, to: Date()), forKey: type)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("failure happened %@", error.localizedDescription)
    }
}

// MARK: - Location Delegate
protocol LocationDelegate: AnyObject {
    func receivedLocation(_ location: CLLocation)
}


