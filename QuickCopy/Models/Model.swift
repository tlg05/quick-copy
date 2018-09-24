//
//  Model.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/22.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Foundation
import SQLite

class Model {
    
    init() {
        
    }
    
    static public func openDB() -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory, .userDomainMask, true
            ).first! + "/" + Bundle.main.bundleIdentifier!
        
        // create parent directory iff it doesn’t exist
        try! FileManager.default.createDirectory(
            atPath: path, withIntermediateDirectories: true, attributes: nil
        )
        
        let db = try! Connection("\(path)/db.sqlite3")
        return db
    }
}
