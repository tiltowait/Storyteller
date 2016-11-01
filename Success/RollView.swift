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
    var difficulty: Int = 6
    var specialized = false

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        if self.rolls.count == 0 { //give some instructions if we haven't rolled anything
            drawBlank()
            return
        }
        
        var x: CGFloat = 0.0
        var y: CGFloat = self.frame.height - side
        
        for roll in self.rolls {
            //calculate the colors
            var foregroundColor: NSColor
            var backgroundColor: NSColor
            
            switch roll {
            case 1:
                foregroundColor = NSColor.white
                backgroundColor = NSColor.red
            case self.difficulty...10:
                foregroundColor = NSColor.black
                backgroundColor = NSColor.init(red: 0.7843137255, green: 1.0, blue: 0.7843137255, alpha: 1.0)
                
                if specialized && roll == 10 {
                    foregroundColor = NSColor.white
                    backgroundColor = NSColor.green
                }
            default:
                foregroundColor = NSColor.black
                backgroundColor = NSColor.init(red: shade, green: shade, blue: shade, alpha: 1.0)
            }
            
            //draw the rectangle
            let rect = NSMakeRect(x, y, self.side, self.side)
            backgroundColor.set()
            NSBezierPath.init(roundedRect: rect, xRadius: 3.0, yRadius: 3.0).fill()
            
            let style: NSMutableParagraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
            style.alignment = NSTextAlignment.center
            let font = NSFont.boldSystemFont(ofSize: 18)
            
            //draw the string
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
    
    func set(rolls: [Int], difficulty: Int, specialized: Bool) {
        self.rolls = rolls
        self.difficulty = difficulty
        self.needsDisplay = true
        self.specialized = specialized
    }
    
    func set(difficulty: Int) {
        self.difficulty = difficulty
        self.needsDisplay = true
    }
    
    func set(specialized: Bool) {
        self.specialized = specialized
        self.needsDisplay = true
    }
    
    func drawBlank() {
        let instructions = "Click a dice pool on\nthe left to begin" as NSString
        let style: NSMutableParagraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.center
        let font = NSFont.boldSystemFont(ofSize: 18)
        let attributes = [ NSFontAttributeName: font,
                           NSForegroundColorAttributeName: NSColor.gray,
                           NSParagraphStyleAttributeName: style ]
        let drawHeight = instructions.size(withAttributes: attributes).height
        let y: CGFloat = (self.frame.height - drawHeight) / 2 + 20
        let rect = NSMakeRect(0.0, y, self.frame.width, drawHeight)
        
        instructions.draw(in: rect, withAttributes: attributes)
    }
    
}
