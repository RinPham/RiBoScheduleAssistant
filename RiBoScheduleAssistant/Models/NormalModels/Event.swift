//
//  Event.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import SwiftyJSON

class Event {
    
    var id: String
    var title: String
    var location: String
    var startDate: Date
    var endDate: Date
    var des: String
    
    init(id: String, title: String, location: String, startDate: Date, endDate: Date, des: String) {
        self.id = id
        self.title = title
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.des = des
    }
    
    init(_ data: JSON) {
        self.id = data["id"].string ?? ""
        self.title = data["summary"].string ?? ""
        self.location = data["location"].string ?? ""
        var start = data["start"]["dateTime"].string ?? ""
        if start == "" {
            start = data["start"]["date"].string ?? ""
        }
        var end = data["end"]["dateTime"].string ?? ""
        if end == "" {
            end = data["end"]["date"].string ?? ""
        }
        self.startDate = start.toDateTimeEvent
        self.endDate = end.toDateTimeEvent
        self.des = data["description"].string ?? ""
    }
    
    init(_ rEvent: REvent) {
        self.id = rEvent.id
        self.title = rEvent.title
        self.location = rEvent.location
        self.startDate = rEvent.startDate
        self.endDate = rEvent.endDate
        self.des = rEvent.des
    }
    
}

class DateEvent {
    
    var event: Any
    var date: Date
    var start: String
    var endDate: String
    var isAllDay = false
    
    init(event: Any, date: Date, start: String, endDate: String, isAllDay: Bool) {
        self.event = event
        self.date = date
        self.start = start
        self.endDate = endDate
        self.isAllDay = isAllDay
    }
    
}
