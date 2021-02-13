//
//  DiceBag.swift
//  Success
//
//  Created by Jared Lindsay on 11/1/16.
//

import Cocoa

class DiceBag {
  private(set) var dice: [Int] = []
  var specialized = true
  var target = 6
  var game = Game.masquerade {
    didSet {
      dice.removeAll()
    }
  }
  
  /// Empties the internal dice array and rolls `pool` number of d10s.
  ///
  /// - Parameter pool: The number of d10s to roll
  func roll(pool: Int) {
    dice.removeAll()
    
    var pool = pool
    var i = 0
    
    while i < pool {
      let roll = Int.random(in: 1...10)
      dice.append(roll)
      
      if game == .requiem && roll >= target { pool += 1 }
      i += 1
    }
  }
  
  var result: Roll {
    if dice.isEmpty { return .none }
    
    let target = game == .masquerade ? self.target : 8
    var successes = dice.filter { $0 >= target }.count
    
    switch game {
    case .masquerade:
      let botches = dice.filter { $0 == 1 }.count
      if specialized {
        successes += dice.filter { $0 == 10 }.count
      }
      
      if successes == 0 && botches > 0 {
        return .botch(-botches)
      } else if successes - botches <= 0 {
        return .failure
      } else {
        return .success(successes - botches)
      }
    case .requiem:
      if successes > 0 {
        return .success(successes)
      }
      return .failure
    }
  }
  
  var successes: Int {
    if dice.count == 0 {
      return -2
    }
    let target = game == .masquerade ? self.target : 8
    var successes = dice.filter { $0 >= target }.count
    
    if game == .masquerade {
      let failures = dice.filter { $0 == 1 }.count
      successes -= failures
      
      if specialized {
        let tens = dice.filter { $0 == 10 }.count
        successes += tens
      }
      
      if successes <= 0 {
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
