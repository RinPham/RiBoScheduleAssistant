//
//  Task.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation
import SwiftyJSON

class Task {
    
    var id: String
    var title: String
    var time: Date
    var content: String
    var isDone: Bool
    var userId: String
    var intentId: String
    
    init(id: String, title: String, time: Date, content: String, isDone: Bool, userId: String, intentId: String) {
        self.id = id
        self.title = title
        self.time = time
        self.content = content
        self.isDone = isDone
        self.userId = userId
        self.intentId = intentId
    }
    
    init(_ data: JSON) {
        self.id = data["id"].string ?? ""
        self.title = data["title"].string ?? ""
        let timeString = data["at_time"].string ?? ""
        self.time = timeString.toDateTime
        self.content = data["content"].string ?? ""
        self.isDone = data["done"].bool ?? false
        self.userId = data["user_id"].string ?? ""
        self.intentId = data["intent_id"].string ?? ""
    }
    
}
