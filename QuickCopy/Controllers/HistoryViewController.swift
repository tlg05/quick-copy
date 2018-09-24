//
//  HistoryViewController.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/23.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class HistoryViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableView.delegate = self
        tableView.dataSource = self
        
        EventManager.shared.listen(to: "app.clipboard_string_updated") { (nil) in
            self.reloadData()
        }
    }
    
    @IBAction func onCopy(_ sender: NSButton) {
        let rowIdx = tableView.row(for: sender)
    
        EventManager.shared.trigger(name: "app.text_copying", param: NSPasteboard.general.changeCount + 1)
        
        TextUtil.copy(text: HistoryItemManager.shared.items[rowIdx].string!)
        
        EventManager.shared.trigger(name: "app.text_copied", param: nil)
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "historyCopyMessageSegue"), sender: self)
    }
    
    @IBAction func onAdd(_ sender: NSButton) {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "addHistorySegue"), sender: sender)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == NSStoryboardSegue.Identifier(rawValue: "historyCopyMessageSegue") {
            if let messageVC = segue.destinationController as? MessageViewController {
                messageVC.message = NSLocalizedString("Text copied!", comment: "") as NSString
            }
        } else if segue.identifier == NSStoryboardSegue.Identifier(rawValue: "addHistorySegue") {
            let addButton = sender as! NSButton
            if let editVC = segue.destinationController as? AddHotKeyViewController {
                let rowIdx = tableView.row(for: addButton)
                editVC.prefillText = HistoryItemManager.shared.items[rowIdx].string! as NSString
            }
        }
    }
}

extension HistoryViewController: NSTableViewDataSource {
    public func reloadData() {
        HistoryItemManager.shared.resync()
        self.tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return HistoryItemManager.shared.items.count
    }
}

extension HistoryViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        let item = HistoryItemManager.shared.items[row]
        
        let id_field = cell?.viewWithTag(1) as! NSTextField
        id_field.stringValue = String(row + 1)
        
        let text_field = cell?.viewWithTag(0) as! NSTextField
        text_field.stringValue = TextUtil.wrap(text: item.string!, at: 26)
        
        return cell
    }
}
