//
//  TextUtil.swift
//  QuickCopy
//
//  Created by Ligeng on 2018/9/24.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Foundation

class TextUtil {
    static public func copy(text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: NSPasteboard.PasteboardType.string)
    }
    
    static public func wrap(text: String, at: Int = 10) -> String {
        var result: String! = text
        if result.count > at {
            result = String(text[...text.index(text.startIndex, offsetBy: at - 1)])
            if let wrap_idx = result.index(of: "\n") {
                result = String(result[..<wrap_idx]) + "..."
            } else {
                result = result + "..."
            }
        }
        return result
    }
}
