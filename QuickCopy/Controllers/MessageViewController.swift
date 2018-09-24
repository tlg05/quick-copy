//
//  MessageViewController.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/17.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class MessageViewController: NSViewController {

    @IBOutlet weak var messageLabel: NSTextField!
    @IBOutlet weak var cancelButton: NSButton!
    
    public var message: NSString = ""
    public var canCancel: Bool = false
    public var completeCallback: (() -> ())? = nil
    public var cancelCallback: (() -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.messageLabel.stringValue = message as String
        self.cancelButton.isHidden = !canCancel
    }
    
    @IBAction func onOk(_ sender: Any) {
        self.completeCallback?()
        
        self.dismiss(nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.cancelCallback?()
        
        self.dismiss(nil)
    }
    
}
