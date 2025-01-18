//
//  ViewController.swift
//  BullsEye
//
//  Created by Mohsin Ali Ayub on 18.01.25.
//

import UIKit

class ViewController: UIViewController {
    
    /// The slider to match a randomly chosen target value.
    ///
    /// The user drags this slider to match a target value as close as they can.
    @IBOutlet weak var slider: UISlider!
    
    /// The slider's current value rounded to the nearest integer.
    var currentValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentValue = lroundf(slider.value)
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    @IBAction func showAlert() {
        let message = "The value of the slider is: \(currentValue)"
        
        let alert = UIAlertController(title: "Hello, World",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

