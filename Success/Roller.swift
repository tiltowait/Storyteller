//
//  Roller.swift
//  Success
//
//  Created by Jared Lindsay on 11/1/16.
//  Copyright © 2016 Baciarini's Martial Arts Inc. All rights reserved.
//

import Cocoa

protocol RollerDelegate {
    func rollsUpdated(roller: Roller)
}

class Roller: NSObject {
  private(set) var rolls: [Int] = []
  @objc public var _specialized: NSNumber = NSControl.StateValue.off as NSNumber {
    didSet {
      self.updateDelegates()
    }
  }
  @objc public var _difficulty: NSNumber = 6 {
    didSet {
      self.updateDelegates()
    }
  }
  var specialized: Bool { return _specialized == NSControl.StateValue.on as NSNumber }
  var difficulty: Int {
    get {
      return _difficulty.intValue
    }
  }
  var game = Game.masquerade {
    didSet {
      rolls.removeAll()
      self.updateDelegates()
    }
  }
  var explode: Int { return difficulty }
  
  private var delegates: [RollerDelegate] = []
  
  func roll(dice: Int) {
    rolls.removeAll()
    
    var pool = dice
    var i = 0
    
    while i < pool {
      let roll = Int(arc4random_uniform(10)) + 1
      rolls.append(roll)
      
      if game == .requiem && roll >= explode { pool += 1 }
      i += 1
    }
    updateDelegates()
  }
  
  func successes() -> Int {
    if rolls.count == 0 {
      return -2
    }
    let target = game == .masquerade ? difficulty : 8
    var successes = rolls.filter { $0 >= target }.count
    
    if game == .masquerade {
      let failures = rolls.filter { $0 == 1 }.count
      successes -= failures
      
      if specialized {
        let tens = rolls.filter { $0 == 10 }.count
        successes += tens
      }
      
      if successes < 0 {
        if successes == 0 {
          successes = -1
        } else {
          successes = 0
        }
      }
    }
    
    return successes
  }
  
  func addDelegate(delegate: RollerDelegate) {
    delegates.append(delegate)
  }
  
  func updateDelegates() {
    for delegate in delegates {
      delegate.rollsUpdated(roller: self)
    }
  }
}

enum Game: String {
  case masquerade = "Masquerade"
  case requiem = "Requiem"
}
