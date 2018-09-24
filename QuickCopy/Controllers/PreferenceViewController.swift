//
//  PreferenceViewController.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/9/3.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa
import ServiceManagement

class PreferenceViewController: NSViewController {
    
    @IBOutlet weak var autoStartCheckBox: NSButton!
    @IBOutlet weak var appShortcut: MASShortcutView!
    @IBOutlet weak var languageButton: NSPopUpButton!
    @IBOutlet weak var languageHint: NSTextField!
    
    let launcherAppId = "com.ligeng.QuickCopyLauncher"
    private let global_shortcut_key = "app_shortcut_tmp"
    
    override func viewDidLoad() {
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == launcherAppId
        }
        self.autoStartCheckBox.state = foundHelper ? .on : .off
        
        if Locale.preferredLanguages[0] == "zh-Hans" {
            self.languageButton.selectItem(withTitle: "简体中文")
        } else {
            self.languageButton.selectItem(withTitle: "English")
        }
        
        let keystr = UserDefaults.standard.string(forKey: "app_shortcut")
        if (keystr != nil) {
            let keycodes = keystr?.split(separator: ",")
            let shortcut = MASShortcut(keyCode: UInt(keycodes![0])!, modifierFlags: UInt(keycodes![1])!)
            
            self.appShortcut.setAssociatedUserDefaultsKey(global_shortcut_key,
                                                          withTransformerName: NSValueTransformerName.keyedUnarchiveFromDataTransformerName.rawValue)
            self.appShortcut.shortcutValue = shortcut
        }
    }
    
    override func viewWillDisappear() {
        let new_value = String(appShortcut.shortcutValue.keyCode) + "," + String(appShortcut.shortcutValue.modifierFlags)
        let old_value = UserDefaults.standard.string(forKey: "app_shortcut")
        if (new_value != old_value) {
            UserDefaults.standard.set(new_value, forKey: "app_shortcut")
            EventManager.shared.trigger(name: "pref.app_shortcut_changed")
        }
    }
    
    @IBAction func onClickAutoStart(_ sender: NSButton) {
        let isAuto = sender.state == .on
        SMLoginItemSetEnabled(launcherAppId as CFString, isAuto)
    }
    
    @IBAction func onChangeLanguage(_ sender: NSPopUpButton) {
        let selection = sender.titleOfSelectedItem
        var changed = false
        switch selection {
        case "English":
            if Locale.preferredLanguages[0] == "zh-Hans" {
                changed = true
            }
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        case "简体中文":
            if Locale.preferredLanguages[0] != "zh-Hans" {
                changed = true
            }
            UserDefaults.standard.set(["zh-Hans"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        default:
            if Locale.preferredLanguages[0] == "zh-Hans" {
                changed = true
            }
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
        self.languageHint.isHidden = !changed
    }
    
}
