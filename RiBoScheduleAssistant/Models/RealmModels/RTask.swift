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
    @objc dynamic var isDone: Bool = false
    @objc dynamic var type = 0
    @objc dynamic var repeatType = 0
    @objc dynamic var email: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var isSync = true
    @objc dynamic var action = 0 // 0. none   1. create    2. update   3. delete
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func initWithTask(task: Task, action: Int, isSync: Bool) -> RTask {
        return RTask(value: ["id": task.id, "title": task.title, "time": task.time, "isDone": task.isDone, "type": task.type.rawValue, "repeatType": task.repeatType.rawValue, "email": task.email, "phoneNumber": task.phoneNumber, "action": action, "isSync": isSync])
    }
    
    class func getWithId(id: String) -> RTask? {
        let realm = try! Realm()
        
        return realm.object(ofType: RTask.self, forPrimaryKey: id)
    }
    
    func save() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self)
        }
    }
    
    func update() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func delete(id: String) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(realm.objects(RTask.self).filter("id=%@", id))
        }
    }
}
