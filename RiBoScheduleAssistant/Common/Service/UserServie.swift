//
//  UserServie.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

class UserService: BaseService {
    
    class func loginGoogleAccount(with user: User) {
        let objLink = AppLinks.LOGIN_GOOGLE_ACCOUNT(user: user)
        self.requestService(apiPath: objLink.link, method: .post, parameters: objLink.paramater) { (data, statusCode, errorText) in
            print(data)
        }
    }
    
}
