//
//  File.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/8/27.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class AddHotKeyViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet var textTextView: NSTextView!
    @IBOutlet var noteTextView: NSTextView!
    @IBOutlet weak var visibleButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var shortcutView: MASShortcutView!
    
    public var data: HK? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textTextView.delegate = self
        noteTextView.delegate = self
        
        shortcutView.shortcutValueChange = { (sender) in
            self.saveButton.isEnabled = self.validate()
        }
        
        initData()
    }
    
    private func initData() {
        guard data != nil else {
            return
        }
        
        textTextView.string = data!.text
        noteTextView.string = data!.note!
        visibleButton.state = data!.visible ? .on : .off
        
        let keycodes = data!.shortcut.split(separator: ",")
        let shortcut = MASShortcut(keyCode: UInt(keycodes[0])!, modifierFlags: UInt(keycodes[1])!)
        
        shortcutView.shortcutValue = shortcut
    }
    
    private func validate() -> Bool {
        if textTextView.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            return false
        }
        
        if shortcutView.shortcutValue == nil {
            return false
        }
    
        return true
    }
    
    @IBAction func saveChange(_ sender: NSButton) {
        let hk = (data != nil) ? data! :  HK()
        hk.visible = (visibleButton.state == .on)
        hk.text = textTextView.string
        hk.note = noteTextView.string
        hk.shortcut = String(shortcutView.shortcutValue.keyCode) + "," + String(shortcutView.shortcutValue.modifierFlags)
        hk.save();
        
        let viewController = presenting as! ViewController
        viewController.reloadData()
        
        dismiss(self)
    }

    func textDidChange(_ notification: Notification) {
        saveButton.isEnabled = validate()
    }
}
