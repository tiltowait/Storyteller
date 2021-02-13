//
//  SuccessView.swift
//  Storyteller
//
//  Created by Jared Lindsay on 10/31/16.
//

import Cocoa

class SuccessView: NSView {
  /// Setting the `result` causes the view to redraw.
  var result: RollResult = .none {
    didSet {
      self.needsDisplay = true
    }
  }
  
  /// A basic opacity animation that lasts 0.15s.
  lazy var animation: CABasicAnimation = {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 0.0
    animation.toValue = 1.0
    animation.duration = 0.15
    
    return animation
  }()
  
  /// The internal representation of the view's frame (origin 0,0).
  lazy var backgroundRect: NSRect = {
    NSMakeRect(0.0, 0.0, self.frame.width, self.frame.height)
  }()
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    // Remove the old sublayers after a small delay
    if let oldSublayers = self.layer?.sublayers {
      for layer in oldSublayers {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
          layer.removeFromSuperlayer()
        }
      }
    }
    
    var backgroundColor = NSColor.lightGray
    var foregroundColor = NSColor.systemGray
    var string = "-"
    let successes: Int
    var noRoll = false
    
    switch result {
    case .botch(let severity):
      string = "\(severity)"
      successes = severity
      backgroundColor = .systemRed
      foregroundColor = .white
    case .failure:
      successes = 0
      backgroundColor = .lightRed
      foregroundColor = .black
    case .success(let suxx):
      string = "\(suxx)"
      successes = suxx
      switch successes {
      case 1...2:
        backgroundColor = .marginalSuccess
        foregroundColor = .black
      case 3...4:
        backgroundColor = .fullSuccess
        foregroundColor = .white
      case 5...:
        backgroundColor = .exceptionalSuccess
        foregroundColor = .white
      default:
        break
      }
    case .none:
      successes = Int.min // This number never gets used, because noRoll will be set
      noRoll = true
      break
    }
    
    //set up the layer
    let rect = self.backgroundRect
    let layer = CALayer()
    
    layer.backgroundColor = backgroundColor.cgColor
    layer.frame = rect
    layer.cornerRadius = 8.0
    
    //set up the text
    let successesLabel = CATextLayer()
    let font = NSFont.boldSystemFont(ofSize: 70)
    
    successesLabel.string = string
    successesLabel.alignmentMode = .center
    successesLabel.font = font
    successesLabel.fontSize = 70
    successesLabel.contentsScale = NSScreen.main!.backingScaleFactor
    successesLabel.foregroundColor = foregroundColor.cgColor
    
    let successesHeight = string.size(withAttributes: [ NSAttributedString.Key.font: font ]).height
    let delta: CGFloat = noRoll ? 0 : 14
    let stringRect = NSMakeRect(rect.origin.x, rect.origin.y - (rect.height - successesHeight) / 2 + delta, rect.width, rect.height)
    
    successesLabel.frame = stringRect
    
    layer.addSublayer(successesLabel)
    
    if !noRoll {
      let title = CATextLayer()
      
      switch successes {
      case 1...:
        title.string = successes == 1 ? "SUCCESS" : "SUCCESSES"
      case 0:
        title.string = "FAILURE"
      default:
        title.string = "BOTCH"
      }
      
      title.font = font
      title.fontSize = 18
      
      let titleHeight = "SUCCESS".size(withAttributes: [ NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 18) ]).height
      
      title.frame = NSMakeRect(rect.origin.x, -rect.height + titleHeight + 7, rect.width, rect.height)
      title.foregroundColor = foregroundColor.cgColor
      title.contentsScale = NSScreen.main!.backingScaleFactor
      title.alignmentMode = .center
      
      layer.addSublayer(title)
    }
    
    layer.add(self.animation, forKey: "opacity")
    self.layer?.addSublayer(layer)
  }
}
