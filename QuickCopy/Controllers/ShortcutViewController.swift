//
//  ShortcutViewController.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/23.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class ShortcutViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        EventManager.shared.listen(to: "app.shortcuts_updated") { (nil) in
            self.reloadData()
        }
    }
    
    @IBAction func onMore(_ sender: NSButton) {
        let rowIdx = tableView.row(for: sender)
        let cell = tableView.view(atColumn: 0, row: rowIdx, makeIfNecessary: false) as! SliderTableCellView
        cell.toggle()
    }
    
    @IBAction func onEdit(_ sender: NSButton) {
        performSegue(withIdentifier: "editSegue", sender: sender)
    }
    
    @IBAction func onDelete(_ sender: NSButton) {
        self.performSegue(withIdentifier: "deleteMessageSegue", sender: sender)
    }
    
    @IBAction func onHideText(_ sender: NSButton) {
        let rowIdx = tableView.row(for: sender)
        
        if (rowIdx < HKManager.shared.shortcuts.count) {
            HKManager.shared.shortcuts[rowIdx].setVisible(newValue: (sender.state == .on))
            EventManager.shared.trigger(name: "app.shortcuts_updated")
        } else {
            print("Something's wrong")
        }
    }
    
    @IBAction func onCopyText(_ sender: NSButton) {
        let rowIdx = tableView.row(for: sender)
        TextUtil.copy(text: HKManager.shared.shortcuts[rowIdx].text)
        
        EventManager.shared.trigger(name: "app.text_copied", param: nil)
        performSegue(withIdentifier: "copyMessageSegue", sender: self)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            EventManager.shared.trigger(name: "app.editing", param: nil)
            
            let editButton = sender as! NSButton
            if let editVC = segue.destinationController as? AddHotKeyViewController {
                let rowIdx = tableView.row(for: editButton)
                editVC.data = HKManager.shared.shortcuts[rowIdx]
            }
        } else if segue.identifier == "copyMessageSegue" {
            if let messageVC = segue.destinationController as? MessageViewController {
                messageVC.message = NSLocalizedString("Text copied!", comment: "") as NSString
            }
        } else if segue.identifier == "deleteMessageSegue" {
            if let messageVC = segue.destinationController as? MessageViewController {
                let deleteButton = sender as? NSButton
                let rowIdx = self.tableView.row(for: deleteButton!)
                
                messageVC.message = NSLocalizedString("Are you sure you want to delete this item? You can't undo this operation!", comment: "") as NSString
                messageVC.canCancel = true
                messageVC.completeCallback = { () in
                    EventManager.shared.trigger(name: "app.text_deleted", param: nil)
                    HKManager.shared.shortcuts[rowIdx].delete()
                    self.reloadData()
                }
            }
        }
    }
}

extension ShortcutViewController: NSTableViewDataSource {
    public func reloadData() {
        EventManager.shared.trigger(name: "app.data_reloading", param: nil)
        HKManager.shared.resync()
        self.tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return HKManager.shared.shortcuts.count
    }
}

extension ShortcutViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        let hk = HKManager.shared.shortcuts[row]
        if (tableColumn?.identifier)!.rawValue == "text" {
            let sliderCell = cell as! SliderTableCellView
            
            let text_field = sliderCell.topView.viewWithTag(1) as! NSTextField
            let password_field = sliderCell.topView.viewWithTag(2) as! NSSecureTextField
            text_field.stringValue = hk.break_text(at: 30)
            text_field.isHidden = !hk.visible
            password_field.stringValue = hk.break_text(at: 30)
            password_field.isHidden = hk.visible
            if !(hk.note?.isEmpty)! {
                sliderCell.topView.toolTip = hk.note
            }
            
            let keycodes = hk.shortcut.split(separator: ",")
            let shortcut = MASShortcut(keyCode: UInt(keycodes[0])!, modifierFlags: UInt(keycodes[1])!)
            let textfield = sliderCell.topView.viewWithTag(3) as! NSTextField
            textfield.stringValue = shortcut!.keyCodeString + "+" + shortcut!.modifierFlagsString
            
            let showButton = sliderCell.bottomView.viewWithTag(1) as! NSButton
            showButton.state = hk.visible ? .on : .off
            
        }
        return cell
    }
}
