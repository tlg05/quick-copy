//
//  EventManager.swift
//  QuickCopy
//
//  Created by 特力更 on 2018/8/30.
//  Copyright © 2018 Ligeng. All rights reserved.
//

import Foundation

class EventManager {
    static let shared = EventManager()
    public var eventArr: [EventObj] = []
    
    private init() {

    }
    
    public func listen(to: String!, action: ((Any?) -> ())!) {
        eventArr.append(EventObj(name: to, action: action))
    }
    
    public func trigger(name: String!, param: Any? = nil) {
        for obj in eventArr {
            if obj.name == name {
                let workToDo = obj.action
                workToDo!(param)
            }
        }
    }
}

class EventObj {
    let name: String!
    let action: ((Any?) -> ())!
    
    init(name: String!, action: ((Any?) -> ())!) {
        self.name = name
        self.action = action
    }
}
