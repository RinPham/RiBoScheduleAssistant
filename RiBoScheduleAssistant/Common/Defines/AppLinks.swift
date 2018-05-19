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
    //localhost
    //static var LINK_API = "http://192.168.3.157:8888/api/v1"
    //static var LINK_SOCKET = "ws://192.168.3.157:8888/"
    //Host
    static var LINK_API = "http://35.196.234.119:8000/api/v1"
    static var LINK_SOCKET = "ws://35.196.234.119:8000/"
    
    //User
    static func LOGIN_GOOGLE(code: String) -> ObjectLink {
        let paramater: [String: Any] = ["code": code]
        return ObjectLink(link: LINK_API + "/auth", paramater: paramater)
    }
    
    //Task
    static func CREATE_NEW_TASK(task: Task) -> ObjectLink {
        let paramater: [String: Any] = ["title": task.title, "repeat": task.repeatType.rawValue, "at_time": task.time.toDateAPIFormat, "type": task.type.rawValue]
        return ObjectLink(link: LINK_API + "/task", paramater: paramater)
    }
    
    static func EDIT_TASK(task: Task) -> String {
        return LINK_API + "/task/\(task.id)"
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
    
    //MESSAGES
    static var GET_MESSAGES: String {
        return LINK_API + "/messages"
    }
}
