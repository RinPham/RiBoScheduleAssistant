//
//  Message.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/3/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Message {
    
    //Properties
    var id: String = ""
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Double
    var senderId: String?
    
    init(id: String = "", owner: MessageOwner = .sender, type: MessageType = .text, content: Any = "", timestamp: Double = 0, senderId: String = "") {
        self.id = id
        self.owner = owner
        self.type = type
        self.content = content
        self.timestamp = timestamp
        self.senderId = senderId
    }
    
    class func prepareMessage(_ data: JSON) -> [Message] {
        var result = [Message]()
        let id = data["id"].string ?? ""
        let sender = data["content"]["from_who"].int ?? 0
        let answer = data["content"]["answer_text"].string ?? ""
        let question = data["content"]["question_text"].string ?? ""
        let create = data["created_at"].string ?? ""
        let createTime = create.toDateTimeMessage.timeIntervalSince1970
        let update = data["updated_at"].string ?? ""
        let updateTime = update.toDateTimeMessage.timeIntervalSince1970
        let userId = data["user_id"].string ?? ""
        
        let message1 = Message()
        message1.content = question
        message1.id = id
        message1.owner = sender == 0 ? .ribo : .sender
        message1.timestamp = createTime
        message1.type = .text
        message1.senderId = userId
        result.append(message1)
        
        if answer != "" {
            
            let message = Message()
            message.content = answer
            message.id = id
            message.owner = sender == 0 ? .sender : .ribo
            message.timestamp = updateTime
            message.type = .text
            message.senderId = userId
            result.append(message)
        }
        
        return result
    }
}

