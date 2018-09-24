//
//  HistoryItemManager.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/23.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Foundation

class HistoryItemManager {
    static let shared = HistoryItemManager()
    
    public var items: [HistoryItem] = []
    
    public func resync() {
        items = HistoryItem.select(type: "all")
    }
    
    private init() {
        self.resync()
    }
}
