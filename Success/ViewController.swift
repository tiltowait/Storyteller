//
//  ViewController.swift
//  Success
//
//  Created by Jared Lindsay on 10/28/16.
//

import Cocoa

class ViewController: NSViewController {
  @IBOutlet weak var rollView: RollView!
  @IBOutlet weak var successView: SuccessView!
  
  @IBOutlet weak var slider: NSSlider!
  @IBOutlet weak var targetLabel: NSTextField!
  @IBOutlet weak var specializedCheckBox: NSButton!
  
  var roller = Roller()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    NotificationCenter.default.addObserver(self, selector: #selector(changeGame(_:)), name: NSNotification.Name(rawValue: "ChangeGame"), object: nil)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    if let game = UserDefaults.standard.object(forKey: "Game") as? String {
      self.view.window?.title = game
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeGame"), object: nil, userInfo: ["Game": Game(rawValue: game)!])
    }
  }
  
  @IBAction func rollDice(_ sender: NSMatrix) {
    let pool = sender.selectedCell()!.tag
    roller.roll(dice: pool)
    
    updateDisplays()
  }
  
  @objc func changeGame(_ notification: Notification) {
    let info = notification.userInfo as! [String: Game]
    let game = info["Game"]!
    
    change(game: game)
  }
  
  func change(game: Game) {
    roller.game = game
    switch game {
    case .masquerade:
      slider.minValue = 2.0
      slider.numberOfTickMarks = 9
      slider.integerValue = 6
      targetLabel.stringValue = "6"
      roller.target = 6
      specializedCheckBox.isEnabled = true
      
      self.view.window?.title = "Masquerade"
    case .requiem:
      slider.minValue = 8
      slider.numberOfTickMarks = 3
      slider.integerValue = 10
      targetLabel.stringValue = "10"
      roller.target = 10
      specializedCheckBox.isEnabled = false
      
      self.view.window?.title = "Requiem"
    }
    updateDisplays()
  }
  
  @IBAction func changeTarget(_ sender: NSSlider) {
    roller.target = sender.integerValue
    targetLabel.integerValue = sender.integerValue
    updateDisplays()
  }
  
  @IBAction func toggleSpecialized(_ sender: NSButton) {
    roller.specialized.toggle()
    updateDisplays()
  }
  
  func updateDisplays() {
    rollView.display(roller: roller)
    successView.display(successes: roller.successes)
  }
}
