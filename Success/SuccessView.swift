//
//  SuccessView.swift
//  Success
//
//  Created by Jared Lindsay on 10/31/16.
//  Copyright © 2016 Baciarini's Martial Arts Inc. All rights reserved.
//

import Cocoa

class SuccessView: NSView {
    let shade: CGFloat = 220.0/255.0
    var successes = -2

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let oldSublayers = self.layer?.sublayers
        
        var backgroundColor = NSColor.init(red: shade, green: shade, blue: shade, alpha: 1.0)
        var foregroundColor = NSColor.gray
        var string = "-"
        
        if self.successes != -2 {
            string = "\(self.successes)"
        }
        
        switch self.successes {
        case -1:
            backgroundColor = NSColor.black
            foregroundColor = NSColor.red
            string = "B"
        case 0:
            backgroundColor = NSColor.init(red: 1.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
            foregroundColor = NSColor.black
        case 1:
            backgroundColor = NSColor.orange
            foregroundColor = NSColor.white
        case 2:
            backgroundColor = NSColor.yellow
            foregroundColor = NSColor.black
        case 3:
            backgroundColor = NSColor.init(red: 200.0/255, green: 1.0, blue: 200.0/255, alpha: 1.0)
            foregroundColor = NSColor.black
        case 4:
            backgroundColor = NSColor.green
            foregroundColor = NSColor.white
        case 5...100:
            backgroundColor = NSColor.blue
            foregroundColor = NSColor.white
        default:
            break
        }
        
        //set up the layer
        let rect = self.backgroundRect() //NSMakeRect(x, y, width, height)
        let layer = CALayer()
        
        layer.backgroundColor = backgroundColor.cgColor
        layer.frame = rect
        layer.cornerRadius = 8.0
        
        //set up the text
        let successesLabel = CATextLayer()
        let font = NSFont.boldSystemFont(ofSize: 70)
        
        successesLabel.string = string
        successesLabel.alignmentMode = "center"
        successesLabel.font = font
        successesLabel.fontSize = 70
        successesLabel.contentsScale = NSScreen.main()!.backingScaleFactor
        successesLabel.foregroundColor = foregroundColor.cgColor
        
        let successesHeight = string.size(withAttributes: [ NSFontAttributeName: font ]).height
        let delta: CGFloat = self.successes < 0 ? 0 : 14
        let stringRect = NSMakeRect(rect.origin.x, rect.origin.y - (rect.height - successesHeight) / 2 + delta, rect.width, rect.height)
        
        successesLabel.frame = stringRect
        
        layer.addSublayer(successesLabel)
        
        if self.successes >= 0 {
            let title = CATextLayer()
            title.string = self.successes == 1 ? "SUCCESS" : "SUCCESSES"
            title.font = font
            title.fontSize = 18
            
            let titleHeight = "SUCCESS".size(withAttributes: [ NSFontAttributeName: NSFont.boldSystemFont(ofSize: 18) ]).height
            
            title.frame = NSMakeRect(rect.origin.x, -rect.height + titleHeight + 7, rect.width, rect.height)
            title.foregroundColor = foregroundColor.cgColor
            title.contentsScale = NSScreen.main()!.backingScaleFactor
            title.alignmentMode = "center"
            
            layer.addSublayer(title)
        }
        
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.15
        
        layer.add(animation, forKey: "opacity")
        self.layer?.addSublayer(layer)
        
        if oldSublayers != nil {
            for layer in oldSublayers! {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func backgroundRect() -> NSRect {
        return NSMakeRect(0.0, 0.0, self.frame.width, self.frame.height)
    }
    
    func set(successes: Int) {
        self.successes = successes
        self.needsDisplay = true
    }
}
