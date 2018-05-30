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
    
    static func GET_TASK(id: String) -> String {
        return LINK_API + "/task/\(id)"
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
    
    static func GET_EVENT(id: String) -> String {
        return LINK_API + "/event/\(id)"
    }
    
    //MESSAGES
    static func GET_MESSAGES(offset: Int) -> ObjectLink {
        let paramater: [String: Any] = ["offset": offset]
        return ObjectLink(link: LINK_API + "/messages", paramater: paramater)
    }
    
    //Sync
    static func SYNC_DATA(createTasks: [Task], updateTasks: [Task], deleteTasks: [Task], createEvents: [Event], updateEvents: [Event], deleteEvents: [Event]) -> ObjectLink {
        var paramater: [String: Any] = [:]
        
        var createTasksPara: [[String: Any]] = []
        for createTask in createTasks {
            let para: [String: Any] = ["title": createTask.title, "repeat": createTask.repeatType.rawValue, "at_time": createTask.time.toDateAPIFormat, "type": createTask.type.rawValue]
            createTasksPara.append(para)
        }
        var createEventsPara: [[String: Any]] = []
        for createEvent in createEvents {
            let para: [String: Any] = ["summary": createEvent.title, "description": createEvent.des, "location": createEvent.location, "start_time": createEvent.startDate.toDateAPIFormat, "end_time": createEvent.endDate.toDateAPIFormat]
            createEventsPara.append(para)
        }
        //paramater["create"] = ["reminders": createTasksPara, "events": createEventsPara]
        
        
        var updateTasksPara: [[String: Any]] = []
        for updateTask in updateTasks {
            let para: [String: Any] = ["id": updateTask.id, "title": updateTask.title, "repeat": updateTask.repeatType.rawValue, "at_time": updateTask.time.toDateAPIFormat, "type": updateTask.type.rawValue]
            updateTasksPara.append(para)
        }
        var updateEventsPara: [[String: Any]] = []
        for updateEvent in updateEvents {
            let para: [String: Any] = ["id": updateEvent.id, "summary": updateEvent.title, "description": updateEvent.des, "location": updateEvent.location, "start_time": updateEvent.startDate.toDateAPIFormat, "end_time": updateEvent.endDate.toDateAPIFormat]
            updateEventsPara.append(para)
        }
        //paramater["update"] = ["reminders": updateTasksPara, "events": updateEventsPara]

        var deleteTasksPara: [[String: Any]] = []
        for deleteTask in deleteTasks {
            let para: [String: Any] = ["id": deleteTask.id]
            deleteTasksPara.append(para)
        }
        var deleteEventsPara: [[String: Any]] = []
        for deleteEvent in deleteEvents {
            let para: [String: Any] = ["id": deleteEvent.id]
            deleteEventsPara.append(para)
        }
//        paramater["delete"] = ["reminders": deleteTasksPara, "events": deleteEventsPara]
        
        var para1: [String: Any] = [:]
        if !createTasksPara.isEmpty {
            para1["reminders"] = createTasksPara
        }
        if !createEventsPara.isEmpty {
            para1["events"] = createEventsPara
        }
        
        var para2: [String: Any] = [:]
        if !updateTasksPara.isEmpty {
            para2["reminders"] = updateTasksPara
        }
        if !updateEventsPara.isEmpty {
            para2["events"] = updateEventsPara
        }
        
        var para3: [String: Any] = [:]
        if !deleteTasksPara.isEmpty {
            para3["reminders"] = deleteTasksPara
        }
        if !deleteEventsPara.isEmpty {
            para3["events"] = deleteEventsPara
        }
        if !para1.isEmpty {
            paramater["create"] = para1
        }
        if !para2.isEmpty {
            paramater["update"] = para2
        }
        if !para3.isEmpty {
            paramater["delete"] = para3
        }
        
        //paramater = ["create": ["reminders": createTasksPara, "events": createEventsPara], "update": ["reminders": updateTasksPara, "events": updateEventsPara], "delete": ["reminders": deleteTasksPara, "events": deleteEventsPara]]
        print(paramater.description)
        
        return ObjectLink(link: LINK_API + "/sync", paramater: paramater)
    }
}
