//
//  CustomView.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/14.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

@IBDesignable class CustomView: NSView {
    
    @IBInspectable var backgroundColor: NSColor = NSColor.windowBackgroundColor
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.layer?.backgroundColor = self.backgroundColor.cgColor
    }
}
