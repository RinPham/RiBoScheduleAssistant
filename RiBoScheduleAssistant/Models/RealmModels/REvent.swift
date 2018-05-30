//
//  REvent.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/28/18.
//Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation
import RealmSwift

class REvent: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var des: String = ""
    @objc dynamic var isSync = true
    @objc dynamic var action = 0 // 0. none   1. create    2. update   3. delete
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func initWithEvent(event: Event, action: Int, isSync: Bool) -> REvent {
        return REvent(value: ["id": event.id, "title": event.title, "location": event.location, "startDate": event.startDate, "endDate": event.endDate, "des": event.des, "action": action, "isSync": isSync])
    }
    
    class func getWithId(id: String) -> REvent? {
        let realm = try! Realm()
        
        return realm.object(ofType: REvent.self, forPrimaryKey: id)
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
            realm.delete(realm.objects(REvent.self).filter("id=%@", id))
        }
    }
}
