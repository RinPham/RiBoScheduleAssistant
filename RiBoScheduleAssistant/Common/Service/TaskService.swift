//
//  TaskService.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

class TaskService: BaseService {
    
    class func createNewTask(with task: Task) {
        let objLink = AppLinks.CREATE_NEW_TASK(task: task)
        self.requestService(apiPath: objLink.link, method: .post, parameters: objLink.paramater) { (data, statusCode, errorText) in
            print(data)
        }
    }
    
}
