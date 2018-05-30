//
//  SyncService.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/28/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import RealmSwift
import SwiftyJSON
import Alamofire

class SyncService: BaseService {
    
    class func syncData(completion: @escaping (_ message: String) -> Void) {
        
        let realm = try! Realm()
        var createTasks = [Task]()
        for rTask in realm.objects(RTask.self).filter("action=%@", 1) {
            createTasks.append(Task.init(rTask))
        }
        
        var updateTasks = [Task]()
        for rTask in realm.objects(RTask.self).filter("action=%@", 2) {
            updateTasks.append(Task.init(rTask))
        }
        
        var deleteTasks = [Task]()
        for rTask in realm.objects(RTask.self).filter("action=%@", 3) {
            deleteTasks.append(Task.init(rTask))
        }
        
        var createEvents = [Event]()
        for rEvent in realm.objects(REvent.self).filter("action=%@", 1) {
            createEvents.append(Event.init(rEvent))
        }
        
        var updateEvents = [Event]()
        for rEvent in realm.objects(REvent.self).filter("action=%@", 2) {
            updateEvents.append(Event.init(rEvent))
        }
        
        var deleteEvents = [Event]()
        for rEvent in realm.objects(REvent.self).filter("action=%@", 3) {
            deleteEvents.append(Event.init(rEvent))
        }
        
        guard !createTasks.isEmpty || !updateTasks.isEmpty || !deleteTasks.isEmpty || !createEvents.isEmpty || !updateEvents.isEmpty || !deleteEvents.isEmpty else {
            completion("Done")
            return
        }
        
        let objLink = AppLinks.SYNC_DATA(createTasks: createTasks, updateTasks: updateTasks, deleteTasks: deleteTasks, createEvents: createEvents, updateEvents: updateEvents, deleteEvents: deleteEvents)
        
        var request = URLRequest(url: URL(string: objLink.link)!)
        request.httpMethod = "POST"
        request.addValue("\(AppLinks.header["Authorization"]!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: objLink.paramater)
        
        Alamofire.request(request)
            .responseJSON { response in
                switch response.result {
                case .failure(let error):
                    completion(error.localizedDescription)
                case .success(let responseObject):
                    print(responseObject)
                    try! realm.write {
                        realm.deleteAll()
                    }
                    completion("Done")
                }
        }
        
//        self.requestService(apiPath: objLink.link, method: .post, parameters: objLink.paramater) { (data, statusText, error) in
//            print(data)
//        }
    }
    
}
