//
//  TaskService.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

class TaskService: BaseService {
    
    class func createNewTask(with task: Task, completion: @escaping Result) {
        let objLink = AppLinks.CREATE_NEW_TASK(task: task)
        self.requestService(apiPath: objLink.link, method: .post, parameters: objLink.paramater) { (data, statusCode, errorText) in
            print(data)
            completion(Task(data), statusCode, errorText)
        }
    }
    
//    class func editTask(with task: Task, completion: @escaping Result) {
//        let objLink = AppLinks.EDIT_TASK(task: task)
//        self.requestService(apiPath: objLink.link, method: .put, parameters: ["id": task.id, "title": task.title , "done": task.isDone]) { (data, statusCode, errorText) in
//            print(data)
//            completion(Task(data), statusCode, errorText)
//        }
//    }
    
    class func editTask(with task: Task, paramater: [String: Any], completion: @escaping Result) {
        self.requestService(apiPath: AppLinks.EDIT_TASK(task: task), method: .put, parameters: paramater) { (data, statusCode, errorText) in
            print(data)
            completion(Task(data), statusCode, errorText)
        }
    }
    
    class func deleteTask(with task: Task , completion: @escaping Result) {
        self.requestService(apiPath: AppLinks.DELETE_TASK(task: task), method: .delete, parameters: nil) { (data, statusCode, errorText) in
            print(data)
            completion("", statusCode, errorText)
        }
    }
    
    class func getListTask(completion: @escaping ListResult) {
        self.requestService(apiPath: AppLinks.GET_LIST_TASK, method: .get, parameters: nil) { (data, statusCode, errorText) in
            print(data)
            if let jsons = data.array {
                var tasks = [Task]()
                for json in jsons {
                    tasks.append(Task(json))
                }
                completion(tasks, statusCode, errorText)
            } else {
                completion([Task](), statusCode, errorText)
            }
        }
    }
    
}
