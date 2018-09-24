//
//  HistoryItem.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/22.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Foundation
import SQLite

class HistoryItem: Model {
    
    var id: Int64?
    var string: String?
    var type: String?
    private var created: TimeInterval?
    
    static let table_name = "history_items"
    
    static let id_col = Expression<Int64>("id")
    static let string_col = Expression<String>("string")
    static let type_col = Expression<String>("type")
    static let created_col = Expression<TimeInterval>("created")
    
    static let max_count = 30
    
    static func setup() {
        let db = openDB()
        let hks = Table("history_items")
        
        try! db.run(hks.create(ifNotExists: true) { t in
            t.column(id_col, primaryKey: .autoincrement)
            t.column(string_col)
            t.column(type_col)
            t.column(created_col)
        })
    }
    
    init(string:String, type:String) {
        super.init()
        
        self.string = string
        self.type = type
        self.created = NSDate().timeIntervalSince1970
    }
    
    init(id: Int64, string: String, type: String, created: TimeInterval) {
        super.init()
        
        self.id = id
        self.string = string
        self.type = type
        self.created = created
    }
    
    static public func select(type: String! = "all") -> [HistoryItem] {
        let db = openDB()
        let items = Table(HistoryItem.table_name)
        var result: [HistoryItem] = []

        do {
            for item in try db.prepare(items.order(created_col.desc).limit(max_count)) {
                let item_obj = HistoryItem(id: item[id_col],
                                           string: item[string_col],
                                           type: item[type_col],
                                           created: item[created_col])
                result.append(item_obj)
            }
        } catch {
            print("failed to select all")
        }
        
        return result
    }
    
    public func save() {
        var db: Connection? = HistoryItem.openDB()
        let items = Table(HistoryItem.table_name)
        
        if self.id != nil {
            do {
                let row = items.filter(HistoryItem.id_col == self.id!)
                if try db?.run(row.update(HistoryItem.string_col <- self.string!, HistoryItem.type_col <- self.type!)) == 0 {
                    print("Updated 0 line")
                }
            } catch {
                print("update failed: \(error)")
            }
        } else {
            do {
                let rowid = try db?.run(items.insert(HistoryItem.string_col <- self.string!, HistoryItem.type_col <- self.type!,
                                                    HistoryItem.created_col <- self.created!))
                self.id = rowid
                
                db = nil
                self.removeOldItems()
            } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
                print("constraint failed: \(message), in \(String(describing: statement))")
            } catch let error {
                print("insertion failed: \(error)")
            }
        }
    }
    
    private func removeOldItems() {
        let db = HistoryItem.openDB()
        do {
            try db.execute("delete from history_items where id not in (select id from history_items order by created desc limit \(HistoryItem.max_count))")
        } catch {
            print("failed to retrieve old items")
        }
    }
}
