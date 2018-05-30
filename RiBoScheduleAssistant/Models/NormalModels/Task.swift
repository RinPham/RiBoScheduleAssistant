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
    var type: TaskType = .normal
    var isDone: Bool
    var userId: String
    var intentId: String
    var repeatType: RepeatType = .none
    var email: String = ""
    var phoneNumber: String = ""
    
    init(id: String, title: String, time: Date, type: TaskType = .normal, isDone: Bool, userId: String, intentId: String, repeatType: RepeatType = .none, email: String = "", phoneNumber: String = "") {
        self.id = id
        self.title = title
        self.time = time
        self.type = type
        self.isDone = isDone
        self.userId = userId
        self.intentId = intentId
        self.repeatType = repeatType
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    init(_ data: JSON) {
        self.id = data["id"].string ?? ""
        self.title = data["title"].string ?? ""
        let timeString = data["at_time"].string ?? ""
        self.time = timeString.toDateTime
        self.isDone = data["done"].bool ?? false
        self.userId = data["user_id"].string ?? ""
        self.intentId = data["intent_id"].string ?? ""
        let repeatInt = data["repeat"].int ?? 0
        if let repeatType = RepeatType(rawValue: repeatInt) {
            self.repeatType = repeatType
        }
        if let typeInt = data["type"].int, let type = TaskType(rawValue: typeInt) {
            self.type = type
        }
        self.email = data["email"].string ?? ""
        self.phoneNumber = data["phone_number"].string ?? ""
    }
    
    init(_ rTask: RTask) {
        self.id = rTask.id
        self.title = rTask.title
        self.time = rTask.time
        self.isDone = rTask.isDone
        self.userId = ""
        self.intentId = ""
        if let repeatType = RepeatType(rawValue: rTask.repeatType) {
            self.repeatType = repeatType
        }
        if let type = TaskType(rawValue: rTask.type) {
            self.type = type
        }
        self.email = rTask.email
        self.phoneNumber = rTask.phoneNumber
    }
}
