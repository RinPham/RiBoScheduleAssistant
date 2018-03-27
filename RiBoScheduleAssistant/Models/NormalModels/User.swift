//
//  User.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    
    var id: String
    var email: String
    var token: String
    var firstName: String
    var lastName: String
    var avatar: String
    
    init(_ data: JSON) {
        
        self.token = data["token"].string ?? ""
        self.id = data["user"]["id"].string ?? ""
        self.email = data["user"]["email"].string ?? ""
        self.firstName = data["user"]["first_name"].string ?? ""
        self.lastName = data["user"]["last_name"].string ?? ""
        self.avatar = data["user"]["avatar"].string ?? ""
        
    }
    
    init(_ dict: [String: String]) {
        
        self.token = dict["token"] ?? ""
        self.id = dict["id"] ?? ""
        self.email = dict["email"] ?? ""
        self.firstName = dict["firstName"] ?? ""
        self.lastName = dict["lastName"] ?? ""
        self.avatar = dict["avatar"] ?? ""
        
    }
}
