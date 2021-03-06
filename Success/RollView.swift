//
//  RollView.swift
//  Storyteller
//
//  Created by Jared Lindsay on 10/31/16.
//

import Cocoa

class RollView: NSView {
  
  // MARK: Display Settings
  let delayIncrement = 0.08
  let side: CGFloat = 35.0
  let spacing: CGFloat = 5.0
  var fullRedraw = true // Determines whether to redraw entire view or just toggle specialty
  
  /// A basic opacity animation that has a duration of 0.25s.
  lazy var animation: CABasicAnimation = {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 0.0
    animation.toValue = 1.0
    animation.duration = 0.25
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    
    return animation
  }()
  
  // MARK: Data Variables
  var dice: [Int] = []
  var target = 6
  var specialty = false
  var game = Game.masquerade
  
  // MARK: - Specialized Setters
  
  /// Sets the `rolls`, `target`, and `specialty` instance variables. The view will then perform a full redraw.
  ///
  /// - Parameters:
  ///     - rolls: The array of dice rolls.
  ///     - target: The difficulty (Masquerade) or "X-again" target (Requiem).
  ///     - specialty: Whether tens should be doubled. (Ignored if game type is Requiem.)
  func set(rolls: [Int], target: Int, specialty: Bool) {
    self.dice = rolls
    self.target = target
    self.fullRedraw = true
    self.specialty = specialty
    self.needsDisplay = true
  }
  
  /// Sets the roll `target` (difficulty or X-again) and performs a partial redraw.
  ///
  /// - Parameters:
  ///     - target: The difficulty (Masquerade) or "X-again" target (Requiem).
  func set(target: Int) {
    self.target = target
    self.fullRedraw = false
    self.needsDisplay = true
  }
  
  /// Sets whether a specialty applies to the roll.
  ///
  /// - Parameter specialty: `True` if tens should be doubled.
  func set(specialty: Bool) {
    self.fullRedraw = false
    self.specialty = specialty
    self.needsDisplay = true
  }
  
  /// Removes all drawn dice results and displays a basic instructional message for the user.
  private func drawInstructions() {
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
  
  //MARK: - Display Handlers
  
  /// Updates the display based on the `diceBag` contents.
  ///
  /// - Parameter diceBag: The new or modified roll to display.
  func display(diceBag: DiceBag) {
    game = diceBag.game
    //need to see what we need to update
    if self.dice == diceBag.dice {
      if diceBag.target == self.target {
        self.set(specialty: diceBag.specialized)
      }
      else {
        if diceBag.game == .masquerade {
          self.set(target: diceBag.target)
        }
      }
    }
    else {
      self.set(rolls: diceBag.dice, target: diceBag.target, specialty: diceBag.specialized)
    }
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    // Drawing code here.
    if self.dice.isEmpty { //give some instructions if we haven't rolled anything
      drawInstructions()
      return
    }
    
    self.layer?.sublayers = nil
    
    var x: CGFloat = 0.0
    var y: CGFloat = self.frame.height - side
    var delay = CACurrentMediaTime()
    
    for die in self.dice {
      //calculate the colors
      var foregroundColor: NSColor
      var backgroundColor: NSColor
      
      switch game {
      case .masquerade:
        switch die {
        case 1:
          foregroundColor = .white
          backgroundColor = .systemRed
        case self.target...10:
          foregroundColor = .black
          backgroundColor = .lightGreen
          
          if specialty && die == 10 {
            foregroundColor = .white
            backgroundColor = .systemGreen
          }
        default:
          foregroundColor = .black
          backgroundColor = .lightGray
        }
      case .requiem:
        switch die {
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
      let dieString = "\(die)"
      
      label.contentsScale = NSScreen.main!.backingScaleFactor
      
      label.string = dieString
      label.foregroundColor = foregroundColor.cgColor
      label.font = font
      label.fontSize = 18
      label.alignmentMode = .center
      
      //calculate vertical center
      let labelHeight = dieString.size(withAttributes: [ NSAttributedString.Key.font: font ]).height
      let labelRect = NSMakeRect(0, 0 - ((self.side - labelHeight) / 2), self.side, self.side)
      
      label.frame = labelRect
      layer.addSublayer(label)
      
      //Perform a nice one-by-one fade-in if we're doing a full redraw
      if self.fullRedraw {
        self.animation.beginTime = delay
        layer.opacity = 0.0
        layer.add(self.animation, forKey: "opacity")
      }
      
      self.layer?.addSublayer(layer)
      
      // Establish the origin and animation delay for the next roll
      x += side + spacing
      delay += delayIncrement
      if x + side > self.frame.width {
        x = 0.0
        y -= side + spacing
      }
    }
  }
}
