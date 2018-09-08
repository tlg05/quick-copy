//
//  RoundedCornerView.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/9/4.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class RoundedCornerView: NSView {
    
    private func drawMaskedCorners(cornerRadius: CGFloat) {
        let mask_layer = CAShapeLayer()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: self.frame.height))
        path.addArc(tangent1End: CGPoint(x: 0.0, y: 0.0),
                    tangent2End: CGPoint(x: self.frame.width, y: 0.0),
                    radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: self.frame.width, y: 0.0),
                    tangent2End: CGPoint(x: self.frame.width, y: self.frame.height),
                    radius: cornerRadius)
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.closeSubpath()
        mask_layer.path = path
        mask_layer.strokeColor = .black
        self.layer?.mask = mask_layer
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let radius: CGFloat = 20.0
        if #available(OSX 10.13, *) {
            self.layer?.cornerRadius = radius
            self.layer?.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
            drawMaskedCorners(cornerRadius: radius)
        }
 
        NSColor.windowBackgroundColor.set()
        dirtyRect.fill()
    }
}
