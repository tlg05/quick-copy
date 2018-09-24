//
//  AboutViewController.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/9/4.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {
    
    @IBOutlet weak var versionLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.versionLabel.stringValue = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
}
