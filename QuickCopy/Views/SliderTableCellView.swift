//
//  CustomTableCellView.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/15.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class SliderTableCellView: NSTableCellView {
    @IBOutlet weak var topView: SliderTopView!
    @IBOutlet weak var bottomView: NSView!
    
    private var status:Bool = false
    
    override func awakeFromNib() {
        self.topView.parent = self
        
        EventManager.shared.listen(to: "app.text_copied") { (nil) in
            self.slideOff()
        }
        
        EventManager.shared.listen(to: "app.window_closed") { (nil) in
            self.slideOff()
        }
        
        EventManager.shared.listen(to: "app.text_deleted") { (nil) in
            self.slideOff()
        }
        
        EventManager.shared.listen(to: "app.data_reloading") { (nil) in
            self.slideOff()
        }
        
        EventManager.shared.listen(to: "app.editing") { (nil) in
            self.slideOff()
        }
        
        EventManager.shared.listen(to: "app.cell_toggling") { (nil) in
            self.slideOff()
        }
    }
    
    public func toggle() {
        EventManager.shared.trigger(name: "app.cell_toggling", param: nil)
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.5
        var origin = self.topView.frame.origin
        origin.x = self.status ? origin.x + 110.0 : origin.x - 110.0
        self.topView.animator().setFrameOrigin(origin)
        NSAnimationContext.endGrouping()
        
        self.status = !self.status
    }
    
    public func slideOff() {
        if (self.status) {
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 0.5
            var origin = self.topView.frame.origin
            origin.x = origin.x + 110.0
            self.topView.animator().setFrameOrigin(origin)
            NSAnimationContext.endGrouping()
            
            self.status = false
        }
    }
}
