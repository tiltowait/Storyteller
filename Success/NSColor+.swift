//
//  NSColor+.swift
//  Storyteller
//
//  Created by Jared Lindsay on 2/6/21.
//

import Cocoa

extension NSColor {
  
  static var lightGray: NSColor {
    NSColor(named: "LightGray")!
  }
  
  static var lightGreen: NSColor {
    NSColor(named: "LightGreen")!
  }
  
  static var lightRed: NSColor {
    NSColor(named: "LightRed")!
  }
  
  static var marginalSuccess: NSColor {
    NSColor.lightGreen
  }
  
  static var fullSuccess: NSColor {
    NSColor(named: "Full Success")!
  }
  
  static var exceptionalSuccess: NSColor {
    NSColor.systemGreen
  }
}
