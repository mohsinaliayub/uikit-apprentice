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
        let authorizationStatus = locationManager.authorizationStatus
        
        // If the user denied location access or it is restricted, display an alert.
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        // Request user's permission to use device's location
        // when the app is running.
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Helper Methods
    
    /// Display an alert to clarify why location updates are not working.
    private func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
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
