//
//  ViewController.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/8/25.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    let appMenu = NSMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HKSet.shared.resync()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        initMenu()
    }
    
    func initMenu() {
        self.appMenu.addItem(NSMenuItem(title: NSLocalizedString("Preferences...", comment: ""), action:#selector(onPreferences), keyEquivalent: ""))
        self.appMenu.addItem(NSMenuItem(title: NSLocalizedString("About...", comment: ""), action:#selector(onAbout), keyEquivalent: ""))
        self.appMenu.addItem(NSMenuItem.separator())
        self.appMenu.addItem(NSMenuItem(title: NSLocalizedString("Quit", comment: ""), action:#selector(onQuit), keyEquivalent: ""))
    }
    
    @objc func onPreferences() {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "preferenceSegue"), sender: self)
    }
    
    @objc func onAbout() {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "aboutSegue"), sender: self)
    }
    
    @objc func onQuit() {
        NSApplication.shared.terminate(self)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func onMenu(_ sender: NSButton) {
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - (sender.frame.height / 2))
        self.appMenu.popUp(positioning: nil, at: p, in: sender.superview)
    }
    
    @IBAction func onHideText(_ sender: NSButton) {
        let rowIdx = tableView.row(for: sender)

        if (rowIdx < HKSet.shared.shortcuts.count) {
            HKSet.shared.shortcuts[rowIdx].setVisible(newValue: (sender.state == .on))
            reloadData()
        } else {
            print("Something's wrong")
        }
    }
    
    @IBAction func onCopyText(_ sender: NSButton) {
        let rowIdx = tableView.row(for: sender)
        HKSet.shared.shortcuts[rowIdx].copyText()
        let view = tableView.view(atColumn: 0, row: rowIdx, makeIfNecessary: false)
        let controller = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "popoverMessageVC"))
        self.presentViewController(controller as! NSViewController,
                                   asPopoverRelativeTo: view!.frame,
                                   of: view!,
                                   preferredEdge: .minX,
                                   behavior: .semitransient)
    }
    
    @IBAction func onEdit(_ sender: NSButton) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "editSegue"), sender: sender)
    }
    
    @IBAction func onDelete(_ sender: NSButton) {
        let answer = confirm(question: NSLocalizedString("Are you sure you want to delete this item?", comment: ""),
                             text: NSLocalizedString("You can't undo this operation", comment: ""))
        if (answer) {
            let rowIdx = tableView.row(for: sender)
            if (rowIdx < HKSet.shared.shortcuts.count) {
                HKSet.shared.shortcuts[rowIdx].delete()
                reloadData()
            } else {
                print("Something's wrong")
            }
        }
    }
    
    func confirm(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == NSStoryboardSegue.Identifier(rawValue: "editSegue") {
            let editButton = sender as! NSButton
            if let editVC = segue.destinationController as? AddHotKeyViewController {
                let rowIdx = tableView.row(for: editButton)
                editVC.data = HKSet.shared.shortcuts[rowIdx]
            }
        }
    }
}

extension ViewController: NSTableViewDataSource {
    public func reloadData() {
        HKSet.shared.resync()
        self.tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return HKSet.shared.shortcuts.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        let hk = HKSet.shared.shortcuts[row]
        if (tableColumn?.identifier)!.rawValue == "text" {
            let password_field = cell?.viewWithTag(1) as! NSSecureTextField
            let text_field = cell?.viewWithTag(2) as! NSTextField
            text_field.stringValue = hk.break_text(at: 20)
            text_field.isHidden = !hk.visible
            password_field.stringValue = hk.break_text(at: 20)
            password_field.isHidden = hk.visible
            if !(hk.note?.isEmpty)! {
                cell?.toolTip = hk.note
            }
        } else if (tableColumn?.identifier)!.rawValue == "shortcut" {
            let keycodes = hk.shortcut.split(separator: ",")
            let shortcut = MASShortcut(keyCode: UInt(keycodes[0])!, modifierFlags: UInt(keycodes[1])!)
            cell?.textField?.stringValue = shortcut!.keyCodeString + "+" + shortcut!.modifierFlagsString
        } else if (tableColumn?.identifier)!.rawValue == "action" {
            let visible_button = cell?.viewWithTag(1) as! NSButton
            visible_button.state = hk.visible ? .on : .off
        } else if (tableColumn?.identifier)!.rawValue == "number" {
            let text_field = cell?.viewWithTag(1) as! NSTextField
            text_field.stringValue = String(row + 1)
        }
        return cell
    }
}
