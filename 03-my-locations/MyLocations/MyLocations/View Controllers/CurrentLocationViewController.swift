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
    /// The latest location asked by the user accurate to the nearest ten meters.
    private var location: CLLocation?
    /// A flag indicating whether the app is busy getting user's location.
    private var updatingLocation = false
    /// The most recent error encountered when fetching user's location.
    private var lastLocationError: Error?
    
    // MARK: Outlets
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var getLocationButton: UIButton!
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }
    
    
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
        
        startLocationManager()
        updateLabels()
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
    
    /// Updates the labels with latest location information, plus updates any messages relevant to the user.
    private func updateLabels() {
        if let location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = statusMessage()
        }
    }
    
    /// Computes a status for the location service updates.
    ///
    /// - Returns: A status message indicating the progress of location updates.
    private func statusMessage() -> String {
        let statusMessage: String
        
        if let error = lastLocationError as NSError? {
            if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                statusMessage = "Location Services Disabled"
            } else {
                statusMessage = "Error Getting Location"
            }
        } else if !CLLocationManager.locationServicesEnabled() {
            statusMessage = "Location Services Disabled"
        } else if updatingLocation {
            statusMessage = "Searching..."
        } else {
            statusMessage = "Tap 'Get My Location' to Start"
        }
        
        return statusMessage
    }
    
    // MARK: Location Manager (Start & Stop)
    
    /// Sets up location manager to fetch current location.
    ///
    /// It sets up a delegate, desired accuracy and starts updating the location.
    private func startLocationManager() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        updatingLocation = true
    }
    
    /// Stops fetching current location's updates.
    private func stopLocationManager() {
        // Only stop if we are fetching any location updates.
        guard updatingLocation else { return }
        
        // Stop location manager. No need for delegate method calls.
        // Change the flag `updatingLocation` to false.
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        updatingLocation = false
    }
}

// MARK: - Location Manager Delegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("didFailWithError \(error.localizedDescription)")
        
        // If the location unknown error is thrown, keep trying for more location updates.
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        // If there's any other error than 'location unknown', save the error and stop location updates.
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        // Save the latest location, clear old errors and update the labels.
        location = newLocation
        lastLocationError = nil
        updateLabels()
    }
}
