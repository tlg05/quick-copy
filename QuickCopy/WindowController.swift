//
//  WindowController.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/8/28.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class BaseWindowController: NSWindowController {
    override func cancelOperation(_ sender: Any?) {
        self.window?.close()
    }
}

@available(OSX 10.12.2, *)
class WindowController: BaseWindowController {
    
    @IBOutlet weak var touchBarScrollView: NSScrollView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        initTouchbar()
    }
    
    func initTouchbar() {
        var contentFrame = CGRect(origin: CGPoint(x: 0, y: 0),
                                  size: CGSize(width: 0, height: self.touchBarScrollView.frame.height))
        let documentView = NSView(frame: contentFrame)
        let horizontal_gap = CGFloat(5.0)
        
        for i in 0...9 {
            if (i >= HKSet.shared.shortcuts.count) {
                break;
            }
            let hk = HKSet.shared.shortcuts[i]
            let button = NSButton(title: hk.break_text(), target: self, action: #selector(onClickTouchbarButton))
            button.tag = i
            
            button.sizeToFit()
            
            var frame = button.frame
            frame.size.height = touchBarScrollView.frame.size.height
            frame.origin = CGPoint(x: contentFrame.origin.x + contentFrame.size.width + horizontal_gap, y: 0)
            button.frame = frame
            
            contentFrame = contentFrame.union(frame)
            documentView.addSubview(button)
            documentView.frame = contentFrame
            self.touchBarScrollView.documentView = documentView
        }
    }
    
    @objc func onClickTouchbarButton(sender: NSButton) {
        HKSet.shared.shortcuts[sender.tag].copyText()
        
        self.window?.close()
    }
}
