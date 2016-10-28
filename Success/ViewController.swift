//
//  ViewController.swift
//  Success
//
//  Created by BMA Staff on 10/28/16.
//  Copyright © 2016 Baciarini's Martial Arts Inc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var rollView: NSTextField!
    @IBOutlet weak var resultsView: NSTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        displayRolls(rolls: rolls)
        calculateSuccesses(rolls: rolls)
    }
    
    func displayRolls(rolls: [Int]) {
        var output = ""
        var current = 1
        
        for roll in rolls {
            output = "\(output)\(roll)"
            if current < 8 {
                output = "\(output)\t"
            }
            else {
                output = "\(output)\n"
                current = 1
            }
            current += 1
        }
        self.rollView.stringValue = output
    }
    
    func calculateSuccesses(rolls: [Int]) {
        var finalOutput = ""
        var numTens = 0
        
        for roll in rolls {
            if roll == 10 {
                numTens += 1
            }
        }
        
        for difficulty in 3...10 {
            var successes = 0
            var botches = 0
            
            for roll in rolls {
                if roll >= difficulty {
                    successes += 1
                }
                else if roll == 1 {
                    botches += 1
                }
            }
            
            let specialtySuccesses = successes + numTens
            var output = "\(difficulty):"
            
            if successes == 0 && botches >= 1 {
                output = "\(output)\tBOTCH"
            }
            else if botches >= successes {
                output = "\(output)\tFailure"
                
                if numTens > 0 {
                    if botches < specialtySuccesses {
                        output = "\(output)\t\t(\(specialtySuccesses - botches))"
                    }
                }
            }
            else {
                output = "\(output)\t\(successes - botches)"
                if numTens > 0 {
                    output = "\(output)\t\t\t(\(specialtySuccesses - botches))"
                }
            }
            
            finalOutput = "\(finalOutput)\(output)\n"
        }
        self.resultsView.stringValue = finalOutput
    }

}

