//
//  HotKeySet.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/8/26.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Foundation

class HKSet {
    static let shared = HKSet()
    
    public var shortcuts: [HK] = []
    
    public func resync() {
        shortcuts = HK.select_all()
    }
    
    private init() {
        
    }
}
