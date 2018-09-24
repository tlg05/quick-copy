//
//  SliderTopView.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/17.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class SliderTopView: CustomView {
    
    public var parent: SliderTableCellView? = nil
    
    override func mouseDown(with event: NSEvent) {
        self.parent?.slideOff()
    }
}
