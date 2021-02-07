//
//  AppDelegate.swift
//  Success
//
//  Created by Jared Lindsay on 10/28/16.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet weak var masqueradeMenu: NSMenuItem!
  @IBOutlet weak var requiemMenu: NSMenuItem!
  
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    let defaults = UserDefaults.standard
    
    guard let string = defaults.object(forKey: "Game") as? String else { return }
    if let game = Game(rawValue: string) {
      toggleMenuItems(game: game)
    }
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
    guard let game = Game(rawValue: sender.title) else { return }
    
    toggleMenuItems(game: game)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeGame"), object: nil, userInfo: ["Game": game])
  }
  
  func toggleMenuItems(game: Game) {
    switch game {
    case .masquerade:
      masqueradeMenu.state = .on
      requiemMenu.state = .off
    case .requiem:
      masqueradeMenu.state = .off
      requiemMenu.state = .on
    }
  }
}

