//
//  AppID.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation

struct AppID {
    
    
    //View Controller ID
    static let IDMainTabbarController = "IDMainTabbarController"
    
    
    //Segue ID
    static let IDAllTaskVCToAddNewTaskVC = "IDAllTaskVCToAddNewTaskVC"
    static let IDCalendarVCToAddNewEventVC = "IDCalendarVCToAddNewEventVC"
    static let IDAllTaskVCToEditTaskVC = "IDAllTaskVCToEditTaskVC"
    static let IDCalendarToEventDetailVC = "IDCalendarToEventDetailVC"
    static let IDEventDetailToEditEventVC = "IDEventDetailToEditEventVC"
    
    
    //TableViewCell ID
    static let IDAllTaskTableViewCell = "IDAllTaskTableViewCell"
    static let IDCalendarTableViewCell = "IDCalendarTableViewCell"
    static let IDEventDetailTableViewCell = "IDEventDetailTableViewCell"
    static let IDHeaderEventTableViewCell = "IDHeaderEventTableViewCell"
    
    //CollectionViewCell ID
    
}

struct UserDefaultsKey {
    
    static let GOOGLE_USER = "Save google user when login successful"
    
}
