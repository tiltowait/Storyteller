//
//  RollView.swift
//  Success
//
//  Created by Jared Lindsay on 10/31/16.
//

import Cocoa

class RollView: NSView {
  let delayIncrement = 0.08
  
  let side: CGFloat = 35.0
  let spacing: CGFloat = 5.0
  
  var rolls: [Int] = []
  var target: Int = 6
  var specialized = false
  var totalUpdate = true
  var game: Game = .masquerade
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    // Drawing code here.
    if self.rolls.count == 0 { //give some instructions if we haven't rolled anything
      drawInstructions()
      return
    }
    
    self.layer?.sublayers = nil
    
    var x: CGFloat = 0.0
    var y: CGFloat = self.frame.height - side
    var delay = CACurrentMediaTime()
    
    for roll in self.rolls {
      //calculate the colors
      var foregroundColor: NSColor
      var backgroundColor: NSColor
      
      if game == .masquerade {
        switch roll {
        case 1:
          foregroundColor = .white
          backgroundColor = .systemRed
        case self.target...10:
          foregroundColor = .black
          backgroundColor = .lightGreen
          
          if specialized && roll == 10 {
            foregroundColor = .white
            backgroundColor = .systemGreen
          }
        default:
          foregroundColor = .black
          backgroundColor = .lightGray
        }
      } else {
        switch roll {
        case 1..<8:
          foregroundColor = .black
          backgroundColor = .lightGray
        case target...10:
          foregroundColor = .white
          backgroundColor = .systemGreen
        default:
          foregroundColor = .black
          backgroundColor = .lightGreen
        }
      }
      
      //create the layer
      let rect = NSMakeRect(x, y, self.side, self.side)
      let layer = CALayer()
      
      layer.frame = rect
      layer.backgroundColor = backgroundColor.cgColor
      layer.cornerRadius = 3.0
      
      //create the label
      let label = CATextLayer()
      let font = NSFont.boldSystemFont(ofSize: 18)
      let rollString = "\(roll)"
      
      label.contentsScale = NSScreen.main!.backingScaleFactor
      
      label.string = rollString
      label.foregroundColor = foregroundColor.cgColor
      label.font = font
      label.fontSize = 18
      label.alignmentMode = .center
      
      //calculate vertical center
      let labelHeight = rollString.size(withAttributes: [ NSAttributedString.Key.font: font ]).height
      let labelRect = NSMakeRect(0, 0 - ((self.side - labelHeight) / 2), self.side, self.side)
      
      label.frame = labelRect
      layer.addSublayer(label)
      
      //create the animation
      if self.totalUpdate {
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.25
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.beginTime = delay
        
        layer.opacity = 0.0
        layer.add(animation, forKey: "opacity")
      }
      
      self.layer?.addSublayer(layer)
      
      x += side + spacing
      delay += delayIncrement
      if x + side > self.frame.width {
        x = 0.0
        y -= side + spacing
      }
    }
  }
  
  func set(roller: Roller) {
    self.set(rolls: roller.rolls, target: roller.target, specialized: roller.specialized)
  }
  
  func set(rolls: [Int], target: Int, specialized: Bool) {
    self.rolls = rolls
    self.target = target
    self.totalUpdate = true
    self.specialized = specialized
    self.needsDisplay = true
  }
  
  func set(target: Int) {
    self.target = target
    self.totalUpdate = false
    self.needsDisplay = true
  }
  
  func set(specialized: Bool) {
    self.totalUpdate = false
    self.specialized = specialized
    self.needsDisplay = true
  }
  
  func drawInstructions() {
    self.layer?.sublayers = nil
    
    let instructions = "Click a dice pool on\nthe left to begin" as NSString
    let style: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    style.alignment = NSTextAlignment.center
    let font = NSFont.boldSystemFont(ofSize: 18)
    let attributes = [ NSAttributedString.Key.font: font,
                       NSAttributedString.Key.foregroundColor: NSColor.systemGray,
                       NSAttributedString.Key.paragraphStyle: style ]
    let drawHeight = instructions.size(withAttributes: attributes).height
    let y: CGFloat = (self.frame.height - drawHeight) / 2 + 20
    let rect = NSMakeRect(0.0, y, self.frame.width, drawHeight)
    
    instructions.draw(in: rect, withAttributes: attributes)
  }
  
  //delegate methods
  func display(roller: Roller) {
    game = roller.game
    //need to see what we need to update
    if self.rolls == roller.rolls {
      if roller.target == self.target {
        self.set(specialized: roller.specialized)
      }
      else {
        if roller.game == .masquerade {
          self.set(target: roller.target)
        }
      }
    }
    else {
      self.set(roller: roller)
    }
  }
}
