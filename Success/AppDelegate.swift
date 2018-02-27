//
//  AppDelegate.swift
//  Success
//
//  Created by BMA Staff on 10/28/16.
//  Copyright © 2016 Baciarini's Martial Arts Inc. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet weak var masqueradeMenu: NSMenuItem!
  @IBOutlet weak var requiemMenu: NSMenuItem!
  
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    let defaults = UserDefaults.standard
    let menuItem = NSMenuItem()
    
    if let game = defaults.object(forKey: "Game") as? String {
      menuItem.title = game
    } else {
      menuItem.title = "Masquerade"
    }
    changeGame(menuItem)
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
    let defaults = UserDefaults.standard
    defaults.set(game().rawValue, forKey: "Game")
  }
  
  func game() -> Game {
    return requiemMenu.state == .on ? .requiem : .masquerade
  }
  
  @IBAction func changeGame(_ sender: NSMenuItem) {
    let game: Game
    
    switch sender.title {
    case "Masquerade":
      game = .masquerade
      masqueradeMenu.state = .on
      requiemMenu.state = .off
    case "Requiem":
      game = .requiem
      masqueradeMenu.state = .off
      requiemMenu.state = .on
    default:
      return
    }
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeGame"), object: nil, userInfo: ["Game": game])
  }
}

