//
//  AppDelegate.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/8/25.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa
import HotKey
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var hotKey: HotKey? = nil
    var mainWindow: NSWindow? = nil
    var isRelaunch = false
    var clipboardTimer: Timer?
    var clipboardChangeCount = 0
    private var ignoreCount = -1
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initUI()
    
        initData()
        
        initEvents()
        
        setupAppHotKey()
    }
    
    private func initUI() {
        mainWindow = NSApplication.shared.windows.last!
        mainWindow?.delegate = self
        mainWindow!.close()
        
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.target = self
        }
    }
    
    private func initData() {
        if !UserDefaults.standard.bool(forKey: "initiated") {
            if NSLocale.current.identifier == "zh-Hans" && Locale.preferredLanguages[0] != "zh-Hans" {
                UserDefaults.standard.set(["zh-Hans"], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                relaunch()
            } else {
                UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
            }
            
            UserDefaults.standard.set(true, forKey: "initiated")
        }
        if UserDefaults.standard.string(forKey: "app_shortcut") == nil {
            UserDefaults.standard.set("9,262144", forKey: "app_shortcut")
        }
        
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
        
        // Model setup
        HK.setup()
        HistoryItem.setup()
    }
    
    private func initEvents() {
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.leftMouseDown,
                                         handler: { (event: NSEvent) -> NSEvent? in
                                            if (event.window == self.statusItem.button?.window) {
                                                self.statusItemClicked()
                                                return nil
                                            }
                                            return event
        })
        
        NSEvent.addGlobalMonitorForEvents(matching: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown],
                                          handler: {(event: NSEvent) in
                                            self.mainWindow?.close();
                                            
        })
        
        EventManager.shared.listen(to: "app.text_copying") { (data) in
            self.ignoreCount = data as! Int
        }
        
        EventManager.shared.listen(to: "pref.app_shortcut_changed") { (nil) in
            self.setupAppHotKey()
        }
        
        clipboardChangeCount = NSPasteboard.general.changeCount
        clipboardTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(detectClipboardChange),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func detectClipboardChange() {
        if (NSPasteboard.general.changeCount > clipboardChangeCount) {
            if (NSPasteboard.general.changeCount != self.ignoreCount) {
                clipboardChanged()
            }
            clipboardChangeCount = NSPasteboard.general.changeCount
        }
    }
    
    private func clipboardChanged() {
        let pasteItem = NSPasteboard.general.pasteboardItems?.first
        if (pasteItem?.types.contains(NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")))! {
            let data = pasteItem?.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text"))
            let newHistoryItem = HistoryItem(string: data!, type: "public.utf8-plain-text")
            newHistoryItem.save()
            EventManager.shared.trigger(name: "app.clipboard_string_updated")
        } else {
            // TODO: Support other types like image/file
        }
    }
    
    func setupAppHotKey() {
        let keystr = UserDefaults.standard.string(forKey: "app_shortcut")
        if (keystr == nil) {
            return
        }
        let keycodes = keystr!.split(separator: ",")
        let shortcut = MASShortcut(keyCode: UInt(keycodes[0])!, modifierFlags: UInt(keycodes[1])!)
        self.hotKey = HotKey(carbonKeyCode: (shortcut?.carbonKeyCode)!, carbonModifiers: (shortcut?.carbonFlags)!)
        
        self.hotKey?.keyDownHandler = {
            self.statusItemClicked()
        }
    }
    
    func statusItemClicked() {
        if (mainWindow?.isVisible)! {
            mainWindow?.close()
            statusItem.button?.state = .off
            statusItem.button?.isHighlighted = false
        } else {
            showWindow(nil)
            statusItem.button?.state = .on
            statusItem.button?.isHighlighted = true
        }
    }
    
    func relaunch() {
        isRelaunch = true
        NSApplication.shared.terminate(nil)
        exit(0)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        if isRelaunch {
            let appPath = Bundle.main.bundlePath
            let process =  Process()
            process.launchPath = "/usr/bin/open"
            process.arguments = [appPath]
            process.launch()
        }
    }

    @objc func showWindow(_ sender: Any?) {
        var pos = NSPoint()
        let statusItemPos = statusItem.button?.window?.convertToScreen((statusItem.button?.frame)!)
        pos.x = (statusItemPos?.origin.x)! + (statusItemPos?.size.width)! - (mainWindow?.frame.width)!
        pos.y = (NSScreen.main?.visibleFrame.origin.y)! + (NSScreen.main?.visibleFrame.size.height)! - (mainWindow?.frame.size.height)!
        
        mainWindow?.setFrameOrigin(pos)
        mainWindow!.makeKeyAndOrderFront(nil)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    public func windowWillClose(_ notification: Notification) {
        statusItem.button?.state = .off
        statusItem.button?.isHighlighted = false
    }
}

