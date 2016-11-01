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
        
        //draw the rectangle
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        let x: CGFloat = (self.frame.width - width)
        let y: CGFloat = (self.frame.height - height) / 2
        let rect = NSMakeRect(x, y, width, height)
        
        backgroundColor.set()
        NSBezierPath.init(roundedRect: rect, xRadius: 8.0, yRadius: 8.0).fill()
        
        //draw the text
        let style: NSMutableParagraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.center
        let font = NSFont.boldSystemFont(ofSize: 70)
        var attributes = [ NSParagraphStyleAttributeName: style,
                           NSForegroundColorAttributeName: foregroundColor,
                           NSFontAttributeName: font ] as [String : Any]
        
        let heightForStringDrawing = string.size(withAttributes: attributes).height
        
        let delta: CGFloat = self.successes < 0 ? 0 : 14
        let stringRect = NSMakeRect(x, (y - (height - heightForStringDrawing) / 2 + delta), width, height)
        
        string.draw(in: stringRect, withAttributes: attributes)
        
        if self.successes >= 0 {
            let successes: NSString = self.successes == 1 ? "SUCCESS" : "SUCCESSES"
        
            attributes[NSFontAttributeName] = NSFont.boldSystemFont(ofSize: 18)
            let successesRect = NSMakeRect(x, y + 7, width, successes.size(withAttributes: attributes).height)
            successes.draw(in: successesRect, withAttributes: attributes)
        }
    }
    
    func set(successes: Int) {
        self.successes = successes
        self.needsDisplay = true
    }
}
