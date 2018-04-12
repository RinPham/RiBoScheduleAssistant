//
//  MessagesSevice.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/11/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

class MessagesService: BaseService {
    class func getListMessages(completion: @escaping ListResult) {
        self.requestService(apiPath: AppLinks.GET_MESSAGES, method: .get, parameters: nil) { (data, statusCode, errorText) in
            print(data)
            if let jsons = data.array {
                var messages = [Message]()
                for json in jsons {
                    messages.append(contentsOf: Message.prepareMessage(json))
                }
                completion(messages, statusCode, errorText)
            } else {
                completion([Message](), statusCode, errorText)
            }
        }
    }
}
