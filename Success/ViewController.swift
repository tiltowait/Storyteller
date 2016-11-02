//
//  ViewController.swift
//  Success
//
//  Created by BMA Staff on 10/28/16.
//  Copyright © 2016 Baciarini's Martial Arts Inc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var rollView: RollView!
    @IBOutlet weak var successView: SuccessView!
    @IBOutlet var roller: Roller!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.roller.addDelegate(delegate: self.rollView)
        self.roller.addDelegate(delegate: self.successView)
    }

    @IBAction func rollDice(_ sender: NSMatrix) {
        let pool = sender.selectedCell()!.tag
        roller.roll(dice: pool)
    }
}

