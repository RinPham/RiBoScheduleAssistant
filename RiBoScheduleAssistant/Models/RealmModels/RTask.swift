//
//  RTask.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation
import RealmSwift

class RTask: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var time: Date = Date()
    @objc dynamic var des: String = ""
    @objc dynamic var isDone: Bool = false
    
    
}
