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
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
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

