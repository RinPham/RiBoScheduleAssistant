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
    static let LINK_API = ""
    
    //User
    static func LOGIN_GOOGLE_ACCOUNT(user: User) -> ObjectLink {
        let paramater: [String: Any] = ["email": user.email, "access_token": user.accessToken, "refresh_token": user.refreshToken, "expire_time": user.expireTime, "fullname": user.name]
        return ObjectLink(link: LINK_API + "/user", paramater: paramater)
    }
    
    
    //Task
    static func CREATE_NEW_TASK(task: Task) -> ObjectLink {
        let paramater: [String: Any] = ["title": task.title, "time": task.time]
        return ObjectLink(link: LINK_API + "/task", paramater: paramater)
    }
    
    
}
