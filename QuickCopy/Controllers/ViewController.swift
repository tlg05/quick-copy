//
//  ViewController.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/8/25.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    //@IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var shortcutButton: NSButton!
    @IBOutlet weak var historyButton: NSButton!
    @IBOutlet weak var tabIndicator: TabIndicatorView!
    @IBOutlet weak var shortcutView: NSView!
    @IBOutlet weak var historyView: NSView!
    
    let appMenu = NSMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HKManager.shared.resync()
        
        // Do any additional setup after loading the view.
        initMenu()
        
        if #available(OSX 10.11, *) {
            self.historyButton.font = NSFont.systemFont(ofSize: 13.0, weight: .regular)
            self.shortcutButton.font = NSFont.systemFont(ofSize: 13.0, weight: .bold)
        }
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
    
    @IBAction func onShortcuts(_ sender: Any) {
        self.tabIndicator.index = 0
        if #available(OSX 10.11, *) {
            self.historyButton.font = NSFont.systemFont(ofSize: 13.0, weight: .regular)
            self.shortcutButton.font = NSFont.systemFont(ofSize: 13.0, weight: .bold)
        }
        self.historyButton.state = .off
        self.shortcutButton.state = .on
        self.historyView.isHidden = true
        self.shortcutView.isHidden = false
    }
    
    @IBAction func onHistory(_ sender: Any) {
        self.tabIndicator.index = 1
        if #available(OSX 10.11, *) {
            self.historyButton.font = NSFont.systemFont(ofSize: 13.0, weight: .bold)
            self.shortcutButton.font = NSFont.systemFont(ofSize: 13.0, weight: .regular)
        }
        self.historyButton.state = .on
        self.shortcutButton.state = .off
        self.historyView.isHidden = false
        self.shortcutView.isHidden = true
    }
}
