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
        
        //displayRolls(rolls: rolls)
        self.rollView.set(rolls: rolls)
        calculateSuccesses(rolls: rolls)
    }
    
    /*
    func displayRolls(rolls: [Int]) {
        let output = NSMutableAttributedString(string: "", attributes: nil)
        var current = 1
        
        for roll in rolls {
            var attribute = [String: Any]()
            switch roll {
            case 1:
                attribute = [ NSForegroundColorAttributeName: NSColor.red ]
            case 10:
                attribute = [ NSForegroundColorAttributeName: NSColor.green ]
            default:
                break
            }
            
            output.append(NSAttributedString(string: "\(roll)", attributes: attribute))
            if current < 8 {
                output.append(NSAttributedString(string: "\t"))
                //output = "\(output)\t"
            }
            else {
                output.append(NSAttributedString(string: "\n"))
                //output = "\(output)\n"
                current = 1
            }
            current += 1
        }
        self.rollView.attributedStringValue = output
    }
 */
    
    func calculateSuccesses(rolls: [Int]) {
        let finalOutput = NSMutableAttributedString(string: "")
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
            let output = NSMutableAttributedString(string: "\(difficulty):")
            
            if successes == 0 && botches >= 1 {
                output.append(NSAttributedString(string: "\tBOTCH", attributes: [ NSForegroundColorAttributeName: NSColor.red, NSFontAttributeName: NSFont.boldSystemFont(ofSize: 18) ]))
            }
            else if botches >= successes {
                output.append(NSAttributedString(string:"\tFailure", attributes: [ NSForegroundColorAttributeName: NSColor.red ]))
            }
            else {
                output.append(NSAttributedString(string: "\t\(successes - botches)\t", attributes: [ NSForegroundColorAttributeName: NSColor.green ]))
            }
            
            if numTens > 0 {
                if botches < specialtySuccesses {
                    output.append(NSAttributedString(string: "\t\t(\(specialtySuccesses - botches))", attributes: [ NSForegroundColorAttributeName: NSColor.green ]))
                }
            }
            
            output.append(NSAttributedString(string: "\n"))
            finalOutput.append(output)
        }
        self.resultsView.attributedStringValue = finalOutput
    }

}

