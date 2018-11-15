//
//  ViewController.swift
//  PA5-mcarter6
//  ViewController runs the program. An event-driven file, each button press updates and runs code
//  CPSC 315-01, Fall 2018
//  Programming Assignment #5
//  Class notes were referenced 
//  Created by Matt Carter on 10/14/18.
//  Copyright © 2018 Matt Carter. All rights reserved.
//



import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var timeLimitStepper: UIStepper!
    @IBOutlet var timeLimitLabel: UILabel!
    @IBOutlet var timeRemainLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!

    var lineCast = false
    var buttonCoord: (Int, Int) = (0, 0)
    var ocean = carpetSea(N: 2)
    var score = 0
    var timer: Timer? = nil
    var totalSeconds = 60
    var seconds = 60 {
        didSet {
            timeRemainLabel.text = "Time: \(seconds)"
        }
    }
    
    // Runs the game. Each second, startTimer() checks to see if there is more time on the clock. If so, it checks to see if a line has been cast, then to see if a fish has been caught. It will give an alert based on whether a fish has been caught or not. Then clears the sea and sets lineCast to true so the user can cast the line again
    // Parameters: n/a
    // Returns: n/a
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) -> Void in
            if self.seconds > 0 {
                self.seconds -= 1
                let tempFishCaught = self.ocean.checkFishCaught(x: self.buttonCoord)
                if self.lineCast == false {
                    if tempFishCaught != nil {
                        let fishCaughtAlert = UIAlertController(title: "Fish Caught", message: tempFishCaught, preferredStyle: .actionSheet)
                        fishCaughtAlert.addAction(UIAlertAction(title: "Keep fishin'!", style: .default, handler: { (action) -> Void in
                            self.updateScore(fish: tempFishCaught!)
                        }))
                        self.present(fishCaughtAlert, animated: true, completion: { () -> Void in})
                    } else {
                        let noFishAlert = UIAlertController(title: "No Fish Caught", message: "You missed the fish this time", preferredStyle: .actionSheet)
                        noFishAlert.addAction(UIAlertAction(title: "Keep fishin'!", style: .default, handler: { (action) -> Void in}))
                        self.present(noFishAlert, animated: true, completion: { () -> Void in})
                    }
                    for i in 0..<self.buttons.count {
                        self.buttons[i].setTitle("", for: UIControl.State.normal)
                    }
                    for x in 0..<self.ocean.N {
                        for y in 0..<self.ocean.N {
                            self.ocean.grid[x][y].containsLine = false
                        }
                    }
                    self.ocean.clearFish(x: self.buttonCoord)
                    self.lineCast = true
                }
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        })
    }
    
    // If there is a fish, it will update the score with the score of the fish
    // Parameters: fish: A String? that is either a fish or nil
    // Returns: n/a
    func updateScore(fish: String?) {
        if fish != nil {
            let tempKey: String = fish!
            if tempKey == "" {
                return
            } else {
                let fishScore: Int = ocean.availableFish["\(tempKey)"]!
                self.score += fishScore
                scoreLabel.text = "Score: \(self.score)"
            }
        }
    }
    
    // Sets the coordinates of each button
    // Parameters: button: a UIButton press from the user
    // Returns: (Int, Int): A tuple that represents the coordinates
    func getCoordinates(_ button: UIButton) -> (Int, Int) {
        switch button {
            case buttons[0]:
                return (0, 0)
            case buttons[1]:
                return (0, 1)
            case buttons[2]:
                return (1, 0)
            case buttons[3]:
                return (1, 1)
            default:
                return (-1, -1)
        }
    }
    
    // Restarts and resets the time, score, and sea on each press
    // Parameters: sender: A UIButton press of the newGameButton
    // Returns: n/a
    @IBAction func newGamePushed(_ sender: UIButton) {
        self.seconds = totalSeconds
        if timer == nil {
            startTimer()
        }
        for i in 0..<buttons.count {
            buttons[i].setTitle("", for: UIControl.State.normal)
        }
        for x in 0..<ocean.N {
            for y in 0..<ocean.N {
                ocean.grid[x][y].containsLine = false
            }
        }
        self.lineCast = true
        self.score = 0
        scoreLabel.text = "Score: 0"
    }
    
    // Increases or decreases the time
    // Parameters: sender: A UIStepper press of the stepper
    // Returns: n/a
    @IBAction func stepperPushed(_ sender: UIStepper){
        self.totalSeconds = Int(sender.value)
        timeLimitLabel.text = ("\(totalSeconds) sec")
    }
    
    // Casts a line on one of the sea options (Cells)
    // Parameters: sender: A UIButton press of the sea options
    // Returns: n/a
    @IBAction func fishingButton(_ sender: UIButton){
        if self.lineCast {
            ocean.randomlyPlaceFish()
            if let index = buttons.index(of: sender) {
                buttons[index].setTitle("⌇", for: UIControl.State.normal)
                buttonCoord = getCoordinates(buttons[index])
                ocean.dropFishingLine(x: buttonCoord)
            }
            self.lineCast = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLimitStepper.minimumValue = 30.0
        timeLimitStepper.maximumValue = 120.0
        timeLimitStepper.autorepeat = true
        timeLimitStepper.wraps = false
        timeLimitStepper.stepValue = 5.0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let instructions = """
        You will be playing Carpet Fishing as inspired
        by Dilbert. You can cast a line into the \"sea\"
        every second and after each second, a fish will
        appear in a random cell. That fish will be
        assigned a point value. Try to get the most points
        The points for each fish are as follows:
        👟: -1 🐟: 1 🐠: 3 🐡: 5
        🦈: 10 🐋: 12 🦑: 15 🧜🏼‍♀️ : 20
        """
        
        let alertController = UIAlertController(title: "Instructions", message: instructions, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Let's go fishin'!", style: .default, handler: { (action) -> Void in
            self.startTimer()
        }))
        present(alertController, animated: true, completion: { () -> Void in})
    }


}

