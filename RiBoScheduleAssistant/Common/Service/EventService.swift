//
//  EventService.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

class EventService: BaseService {
    
    class func getListEvent(completion: @escaping ListResult) {
        self.requestService(apiPath: AppLinks.GET_LIST_EVENT, method: .get, parameters: nil) { (data, statusCode, errorText) in
            print(data)
            if let jsons = data["items"].array {
                var events = [Event]()
                for json in jsons {
                    events.append(Event(json))
                }
                completion(events, statusCode, errorText)
            }
            completion([Event](), statusCode, errorText)
        }
    }
    
    class func createNewEvent(with event: Event, completion: @escaping Result) {
        let objLink = AppLinks.CREATE_NEW_EVENT(event: event)
        self.requestService(apiPath: objLink.link, method: .post, parameters: objLink.paramater) { (data, statusCode, errorText) in
            print(data)
            completion(Event(data), statusCode, errorText)
        }
    }
    
    class func editEvent(with event: Event, completion: @escaping Result) {
        let objLink = AppLinks.EDIT_EVENT(event: event)
        self.requestService(apiPath: objLink.link, method: .put, parameters: objLink.paramater) { (data, statusCode, errorText) in
            print(data)
            completion(Event(data), statusCode, errorText)
        }
    }
    
    class func deleteEvent(with event: Event , completion: @escaping Result) {
        self.requestService(apiPath: AppLinks.DELETE_EVENT(event: event), method: .delete, parameters: nil) { (data, statusCode, errorText) in
            print(data)
            completion("", statusCode, errorText)
        }
    }
    
}
