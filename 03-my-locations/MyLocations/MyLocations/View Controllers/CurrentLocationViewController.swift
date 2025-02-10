//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Mohsin Ali Ayub on 10.02.25.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    // MARK: Properties
    /// Access location updates through this manager.
    private let locationManager = CLLocationManager()
    
    // MARK: Outlets
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var getLocationButton: UIButton!
    
    // MARK: Actions
    
    @IBAction private func getLocation() {
        // Request user's permission to use device's location
        // when the app is running.
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Location Manager Delegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
    }
}
