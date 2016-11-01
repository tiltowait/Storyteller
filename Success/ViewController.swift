//
//  ViewController.swift
//  Success
//
//  Created by BMA Staff on 10/28/16.
//  Copyright © 2016 Baciarini's Martial Arts Inc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var resultsView: NSTextField!
    @IBOutlet weak var rollView: RollView!
    @IBOutlet weak var difficultySlider: NSSlider!
    @IBOutlet weak var difficultyField: NSTextField!
    @IBOutlet weak var specializedCheckbox: NSButton!
    @IBOutlet weak var successView: SuccessView!
    
    var rolls: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDifficulty(self)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func rollDice(_ sender: NSMatrix) {
        let dicePool = sender.selectedCell()!.tag
        var rolls = [Int]()
        
        for _ in 1...dicePool {
            rolls.append(Int(arc4random_uniform(10) + 1))
        }
        
        self.rollView.set(rolls: rolls, difficulty: self.difficultySlider.integerValue, specialized: self.specializedCheckbox.state == NSOnState)
        calculateSuccesses(rolls: rolls)
        
        self.rolls = rolls
    }
    
    @IBAction func setDifficulty(_ sender: Any) {
        let difficulty = self.difficultySlider.integerValue
        
        self.difficultyField.stringValue = "\(difficulty)"
        self.rollView.set(difficulty: difficulty)
        self.calculateSuccesses(rolls: self.rolls)
    }
    
    @IBAction func setSpecialized(_ sender: Any) {
        self.calculateSuccesses(rolls: self.rolls)
        self.rollView.set(specialized: self.specializedCheckbox.state == NSOnState)
    }
    
    func calculateSuccesses(rolls: [Int]) {
        if rolls.count == 0 {
            return
        }
        
        let difficulty = self.difficultySlider.integerValue
        let specialized = self.specializedCheckbox.state == NSOnState
        
        var tens = 0
        var successes = 0
        var botches = 0
        var result = 0
        
        for roll in rolls {
            switch roll {
            case 1:
                botches += 1
            case difficulty..<10:
                successes += 1
            case 10:
                successes += 1
                tens += 1
            default:
                break
            }
        }
        
        if successes == 0 && botches > 0 {
            result = -1
        }
        else if successes > 0 {
            result = successes - botches
            
            if specialized {
                result += tens
            }
        }
        self.successView.set(successes: result)
    }
}

