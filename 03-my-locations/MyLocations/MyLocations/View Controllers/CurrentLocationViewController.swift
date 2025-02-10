//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Mohsin Ali Ayub on 10.02.25.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var getLocationButton: UIButton!
    
    // MARK: Actions
    
    @IBAction private func getLocation() {
        // TODO: fetch location coordinates
    }
}

