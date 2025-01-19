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
    /// The player drags this slider to match a target value as close as they can.
    @IBOutlet weak var slider: UISlider!
    /// The label to display random target value to be matched by the player.
    @IBOutlet weak var targetLabel: UILabel!
    /// The label to display the player's total score aggregated over multiple rounds.
    @IBOutlet weak var scoreLabel: UILabel!
    /// The label to display the current round being played.
    @IBOutlet weak var roundLabel: UILabel!
    
    /// The slider's current value rounded to the nearest integer.
    var currentValue = 0
    /// A random target value the player must try to match as close as they can.
    ///
    /// The random Int value is set when either a new round of the game begins
    /// or the player starts over the game completely. This random value is between
    /// 1 and 100 (inclusive), the slider's minimum and maximum values, respectively.
    var targetValue = 0
    /// The player's total score aggregated over multiple rounds.
    var score = 0
    /// The current round being played.
    ///
    /// The round increments everytime the player makes a match. The round gets reset when a new game starts.
    var round = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // The game just started. Setup a first round.
        startNewRound()
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    @IBAction func showAlert() {
        // Calculate absolute difference between target and current value.
        // The difference needs to be positive, so we don't subtract
        // player's score.
        let difference = abs(targetValue - currentValue)
        // Calculate points for a round.
        let points = points(for: difference)
        score += points
        
        let title = alertTitle(for: difference)
        let message = "You scored \(points) points"
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
        startNewRound()
    }
    
    /// Sets up a new round for the player.
    ///
    /// Updates the target value with a random Int between slider's minimum and maximum value,
    /// plus sets the slider's current value to be halfway in between its minimum and maximum value.
    /// It also updates the UI by display game related information in UILabel(s).
    func startNewRound() {
        // Increment the round.
        round += 1
        // Set a new random target value between 1 and 100,
        // slider's min and max values, respectively.
        targetValue = Int.random(in: 1...100)
        // Set the current value to be halfway between slider's min & max values.
        currentValue = 50
        // Update the slider to halfway position.
        slider.value = Float(currentValue)
        
        updateLabels()
    }
    
    /// Updates the UILabel objects to display game related information.
    func updateLabels() {
        // Display the target value the player needs to match.
        targetLabel.text = String(targetValue)
        // Display the score.
        scoreLabel.text = String(score)
        // Display the current round.
        roundLabel.text = String(round)
    }
    
    // MARK: - Helper(s)
    
    /// Calculates the alert dialog title for point difference between target and current value.
    /// - Parameter difference: The absolute difference between target and current value.
    /// - Returns: A string that depicts how close you did in matching the target value.
    func alertTitle(for difference: Int) -> String {
        let title: String
        if difference == 0 {
            title = "Perfect!"
        } else if difference < 5 {
            title = "You almost had it!"
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close..."
        }
        
        return title
    }
    
    /// Calculates the total points for a difference between target and current value.
    /// - Parameter difference: The absolute difference between target and current value.
    /// - Returns: A score based on player's effort, plus any bonus score.
    ///
    /// The player is awarded additional bonus points on how good they did in matching the target value:
    /// - The player is awarded 100 bonus points if difference is 0.
    /// - The player is awarded 50 bonus points if difference is only 1.
    func points(for difference: Int) -> Int {
        var points = 100 - difference
        if difference == 0 {
            points += 100
        } else if difference == 1 {
            points += 50
        }
        
        return points
    }
}

