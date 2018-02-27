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
  
  @IBOutlet weak var slider: NSSlider!
  @IBOutlet weak var targetLabel: NSTextField!
  @IBOutlet weak var specializedCheckBox: NSButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.roller.addDelegate(delegate: self.rollView)
    self.roller.addDelegate(delegate: self.successView)
    
    NotificationCenter.default.addObserver(self, selector: #selector(changeGame(_:)), name: NSNotification.Name(rawValue: "ChangeGame"), object: nil)
  }
  
  @IBAction func rollDice(_ sender: NSMatrix) {
    let pool = sender.selectedCell()!.tag
    roller.roll(dice: pool)
  }
  
  @objc func changeGame(_ notification: Notification) {
    let info = notification.userInfo as! [String: Game]
    let game = info["Game"]!
    roller.game = info["Game"]!
    
    switch game {
    case .masquerade:
      slider.integerValue = 6
      targetLabel.stringValue = "6"
      roller._difficulty = 6
      specializedCheckBox.isEnabled = true
    case .requiem:
      slider.integerValue = 10
      targetLabel.stringValue = "10"
      roller._difficulty = 10
      specializedCheckBox.isEnabled = false
    }
  }
}
