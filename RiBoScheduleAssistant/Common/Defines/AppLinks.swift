//
//  AppLinks.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation

struct AppLinks {
    
    static var header: [String: String] = [:]
    static let LINK_API = "http://35.196.234.119:8000/api/v1"
    
    //User
    static func LOGIN_GOOGLE(code: String) -> ObjectLink {
        let paramater: [String: Any] = ["code": code]
        return ObjectLink(link: LINK_API + "/auth", paramater: paramater)
    }
    
    //Task
    static func CREATE_NEW_TASK(task: Task) -> ObjectLink {
        let paramater: [String: Any] = ["title": task.title, "content": task.content, "at_time": task.time.toDateAPIFormat]
        return ObjectLink(link: LINK_API + "/task", paramater: paramater)
    }
    
    static func EDIT_TASK(task: Task) -> ObjectLink {
        let paramater: [String: Any] = ["id": task.id,"user_id": task.userId, "intent_id": task.intentId, "title": task.title, "content": task.content, "at_time": task.time.toDateAPIFormat, "done": task.isDone]
        return ObjectLink(link: LINK_API + "/task/\(task.id)", paramater: paramater)
    }
    
    static func DELETE_TASK(task: Task) -> String {
        return LINK_API + "/task/\(task.id)"
    }
    
    static var GET_LIST_TASK: String {
        return LINK_API + "/task"
    }
    
    //EVENT
    static var GET_LIST_EVENT: String {
        return LINK_API + "/event"
    }
    
    static func CREATE_NEW_EVENT(event: Event) -> ObjectLink {
        let paramater: [String: Any] = ["summary": event.title, "description": event.des, "location": event.location, "start_time": event.startDate.toDateAPIFormat, "end_time": event.endDate.toDateAPIFormat]
        return ObjectLink(link: LINK_API + "/event", paramater: paramater)
    }
    
    static func EDIT_EVENT(event: Event) -> ObjectLink {
        let paramater: [String: Any] = ["id": event.id, "summary": event.title, "description": event.des, "location": event.location, "start_time": event.startDate.toDateAPIFormat, "end_time": event.endDate.toDateAPIFormat]
        return ObjectLink(link: LINK_API + "/event/\(event.id)", paramater: paramater)
    }
    
    static func DELETE_EVENT(event: Event) -> String {
        return LINK_API + "/event/\(event.id)"
    }
}
