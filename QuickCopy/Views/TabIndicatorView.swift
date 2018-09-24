//
//  TabIndicatorView.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/15.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

@IBDesignable class TabIndicatorView: CustomView {
    
    @IBInspectable var indicatorColor: NSColor = .white
    @IBInspectable var tabCount: Int = 1
    
    let indicatorLayer = CALayer()
    
    private var _index = 0
    public var index: Int {
        get {
            return self._index
        }
        set {
            self._index = newValue
            self.needsDisplay = true
        }
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    private func indicatorFrame() -> CGRect {
        return CGRect(origin: CGPoint(x: CGFloat(self._index) * self.frame.width / CGFloat(self.tabCount), y: 0),
                     size: CGSize(width: self.frame.size.width / CGFloat(self.tabCount), height: self.frame.size.height))
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.wantsLayer = true
        
        indicatorLayer.frame = self.indicatorFrame()
        indicatorLayer.backgroundColor = self.indicatorColor.cgColor
        
        self.layer?.addSublayer(indicatorLayer)
    }
}
