//
//  RoundedCornerWindow.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/9/4.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class RoundedCornerWindow: NSWindow {
    
    override var canBecomeKey: Bool { return true }
    override var canBecomeMain: Bool { return true }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        self.backgroundColor = .clear
    }
}
