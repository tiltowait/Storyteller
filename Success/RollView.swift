//
//  RollView.swift
//  Success
//
//  Created by Jared Lindsay on 10/31/16.
//  Copyright © 2016 Baciarini's Martial Arts Inc. All rights reserved.
//

import Cocoa

class RollView: NSView {
    let side: CGFloat = 35.0
    let spacing: CGFloat = 5.0
    let shade: CGFloat = 251.0 / 255.0
    var rolls: [Int] = []

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        var x: CGFloat = 0.0
        var y: CGFloat = self.frame.height - side
        
        for roll in self.rolls {
            //draw the rectangle
            let rect = NSMakeRect(x, y, self.side, self.side)
            NSColor.init(red: shade, green: shade, blue: shade, alpha: 1.0).set()
            //NSRectFill(rect)
            NSBezierPath.init(roundedRect: rect, xRadius: 3.0, yRadius: 3.0).fill()
            
            //draw the text
            var foregroundColor = NSColor.black
            switch roll {
            case 1:
                foregroundColor = NSColor.red
            case 10:
                foregroundColor = NSColor.green
            default:
                break
            }
            
            let style: NSMutableParagraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
            style.alignment = NSTextAlignment.center
            let font = NSFont.boldSystemFont(ofSize: 18)
            
            let string = "\(roll)" as NSString
            let attributes = [ NSParagraphStyleAttributeName: style,
                               NSForegroundColorAttributeName: foregroundColor,
                               NSFontAttributeName: font ] as [String : Any]
            
            let heightForStringDrawing = string.size(withAttributes: attributes).height
            let stringRect = NSMakeRect(x, (y - (self.side - heightForStringDrawing) / 2), self.side, self.side)
            
            string.draw(in: stringRect, withAttributes: attributes)
            
            //prepare for next rectangle
            x += side + spacing
            if x + side > self.frame.width {
                x = 0.0
                y -= side + spacing
            }
        }
    }
    
    func set(rolls: [Int]) {
        self.rolls = rolls
        self.needsDisplay = true
    }
    
}
