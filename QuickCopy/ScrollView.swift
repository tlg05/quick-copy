//
//  ScrollView.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/9/2.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Cocoa

// This class is of no use but to suppress the assertion failure.
// The build-in pan gesture recognizer of the NSScrollView need itself to be the delegate
// It may be a cocoa bug
class ScrollView: NSScrollView, NSGestureRecognizerDelegate {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        (self.gestureRecognizers.first as! NSPanGestureRecognizer).delegate = self
    }
}
