//
//  Roller.swift
//  Success
//
//  Created by Jared Lindsay on 11/1/16.
//  Copyright © 2016 Baciarini's Martial Arts Inc. All rights reserved.
//

import Cocoa

class Roller: NSObject {
  private(set) var rolls: [Int] = []
  var specialized = true
  var target = 6
  var game = Game.masquerade {
    didSet {
      rolls.removeAll()
    }
  }
  
  func roll(dice: Int) {
    rolls.removeAll()
    
    var pool = dice
    var i = 0
    
    while i < pool {
      let roll = Int(arc4random_uniform(10)) + 1
      rolls.append(roll)
      
      if game == .requiem && roll >= target { pool += 1 }
      i += 1
    }
  }
  
  var successes: Int {
    if rolls.count == 0 {
      return -2
    }
    let target = game == .masquerade ? self.target : 8
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
}

enum Game: String {
  case masquerade = "Masquerade"
  case requiem = "Requiem"
}
