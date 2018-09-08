//
//  AppDelegate.swift
//  QuickCopyLauncher
//
//  Created by 特力更 on 2018/9/3.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppLauncherDelegate: NSObject {
}

extension AppLauncherDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppIdentifier = "com.ligeng.QuickCopy"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == mainAppIdentifier
        }
        
        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            NSWorkspace.shared.launchApplication(path as String)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

