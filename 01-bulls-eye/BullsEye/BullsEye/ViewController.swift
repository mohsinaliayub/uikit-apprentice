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
    ///
    /// When you set a new value, the slider is automatically updated.
    var currentValue: Int {
        get { lroundf(slider.value) }
        set { slider.value = Float(newValue) }
    }
    /// A random target value the player must try to match as close as they can.
    ///
    /// The random Int value is set when either a new round of the game begins
    /// or the player starts over the game completely. This random value is between
    /// 1 and 100 (inclusive), the slider's minimum and maximum values, respectively.
    ///
    /// The `targetLabel` is updated after you set this property.
    var targetValue = 0 {
        didSet {
            targetLabel.text = String(targetValue)
        }
    }
    /// The player's total score aggregated over multiple rounds.
    ///
    /// The `scoreLabel` is updated with the latest score after you set this property.
    var score = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    /// The current round being played.
    ///
    /// The round increments everytime the player makes a match. The round gets reset when a new game starts.
    ///
    /// The `roundLabel` is updated with the latest score after you set this property.
    var round = 0 {
        didSet {
            roundLabel.text = String(round)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // The game just started. Setup a first round.
        startNewGame()
        // Customize the appearance of the main slider.
        customizeSlider()
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
        
        let title = alertTitle(for: difference)
        let message = "You scored \(points) points"
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.score += points
            self.startNewRound()
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    /// Sets up a fresh game for the player.
    ///
    /// It resets the score, round and target values for the game.
    @IBAction func startNewGame() {
        score = 0
        round = 0
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
    
    
    // MARK: - UI Customization
    /// Customize the appearance of game slider.
    ///
    /// The slider is customized by:
    /// - setting a custom image for slider thumb in both normal and highlighted state
    /// - setting a custom image for the track to the left of the thumb in the slider
    /// - setting a custom image for the track to the right of the thumb in the slider.
    func customizeSlider() {
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!
        slider.setThumbImage(thumbImageHighlighted, for: .normal)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")!
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = UIImage(named: "SliderTrackRight")!
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
}

