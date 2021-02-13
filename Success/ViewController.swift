//
//  ViewController.swift
//  Storyteller
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
  
  var diceBag = DiceBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // If the user changes game, we need to reset the app state, targets, etc.
    NotificationCenter.default.addObserver(self, selector: #selector(changeGame(_:)), name: NSNotification.Name(rawValue: "ChangeGame"), object: nil)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    if let game = UserDefaults.standard.object(forKey: "Game") as? String {
      self.view.window?.title = game
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeGame"), object: nil, userInfo: ["Game": Game(rawValue: game)!])
    }
  }
  
  /// Rolls the dice and updates the roll and success views.
  ///
  /// - Parameter sender: An NSMatrix of buttons, where the tag of the `selectedCell` determines the size of the dice pool.
  @IBAction func rollDice(_ sender: NSMatrix) {
    let pool = sender.selectedCell()!.tag
    diceBag.roll(pool: pool)
    
    updateDisplays()
  }
  
  /// Changes the game type between Masquerade and Requiem. Resets the app state to fresh launch with the game's parameters set.
  /// This function is only called via the notification center.
  ///
  /// - Parameter notification: The `Notification` containing game information
  @objc func changeGame(_ notification: Notification) {
    let info = notification.userInfo as! [String: Game]
    let game = info["Game"]!
    
    diceBag.game = game
    switch game {
    case .masquerade:
      slider.minValue = 2.0
      slider.numberOfTickMarks = 9
      slider.integerValue = 6
      targetLabel.stringValue = "6"
      diceBag.target = 6
      specializedCheckBox.isEnabled = true
      
      self.view.window?.title = game.rawValue
    case .requiem:
      slider.minValue = 8
      slider.numberOfTickMarks = 3
      slider.integerValue = 10
      targetLabel.stringValue = "10"
      diceBag.target = 10
      specializedCheckBox.isEnabled = false
      
      self.view.window?.title = game.rawValue
    }
    updateDisplays()
  }
  
  /// Changes the `target`, whether that is difficulty or X-again, and updates the roll and success views.
  ///
  /// - Parameter sender: The slider that controls the target.
  @IBAction func changeTarget(_ sender: NSSlider) {
    diceBag.target = sender.integerValue
    targetLabel.integerValue = sender.integerValue
    updateDisplays()
  }
  
  /// Toggles the specialty checkbox and updates roll and success views.
  @IBAction func toggleSpecialized(_ sender: NSButton) {
    diceBag.specialized.toggle()
    updateDisplays()
  }
  
  /// Causes the roll and success views to display their new data.
  func updateDisplays() {
    rollView.display(diceBag: diceBag)
    successView.result = diceBag.result
  }
}
