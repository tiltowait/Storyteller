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

public class Roller: NSObject {
    public private(set) var rolls: [Int] = []
    public var _specialized: NSNumber = NSOnState as NSNumber {
        didSet {
            self.specialized = _specialized == NSOnState as NSNumber
            self.updateDelegates()
        }
    }
    public var _difficulty: NSNumber = 6 {
        didSet {
            self.updateDelegates()
        }
    }
    public var specialized = true
    public var difficulty: Int {
        get {
            return _difficulty.intValue
        }
    }
    
    private var delegates: [RollerDelegate] = []
    
    func roll(dice: Int) {
        rolls.removeAll()
        
        for _ in 0..<dice {
            rolls.append(Int(arc4random_uniform(10)) + 1)
        }
        self.updateDelegates()
    }
    
    func successes() -> Int {
        if rolls.count == 0 {
            return -2
        }
        
        var successes = 0
        var botches = 0
        var tens = 0
        var result = 0
        
        for roll in rolls {
            switch roll {
            case 1:
                botches += 1
            case difficulty..<10:
                successes += 1
            case 10:
                successes += 1
                tens += 1
            default:
                break
            }
        }
        
        if botches > 0 && successes == 0 {
            result = -1
        }
        else if successes > 0 {
            result = successes - botches + (specialized ? tens : 0)
            if result < 0 {
                result = 0
            }
        }
        
        return result
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
