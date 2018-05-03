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
    static let IDChatViewController = "IDChatViewController"
    static let IDSpeechViewController = "IDSpeechViewController"
    static let IDLogInViewController = "IDLogInViewController"
    
    //Segue ID
    static let IDAllTaskVCToAddNewTaskVC = "IDAllTaskVCToAddNewTaskVC"
    static let IDCalendarVCToAddNewEventVC = "IDCalendarVCToAddNewEventVC"
    static let IDAllTaskVCToEditTaskVC = "IDAllTaskVCToEditTaskVC"
    static let IDCalendarToEventDetailVC = "IDCalendarToEventDetailVC"
    static let IDEventDetailToEditEventVC = "IDEventDetailToEditEventVC"
    static let IDCalendarToEditTaskVC = "IDCalendarToEditTaskVC"
    
    
    //TableViewCell ID
    static let IDAllTaskTableViewCell = "IDAllTaskTableViewCell"
    static let IDCalendarTableViewCell = "IDCalendarTableViewCell"
    static let IDEventDetailTableViewCell = "IDEventDetailTableViewCell"
    static let IDHeaderEventTableViewCell = "IDHeaderEventTableViewCell"
    static let IDSenderTableViewCell = "IDSenderTableViewCell"
    static let IDReceiverTableViewCell = "IDReceiverTableViewCell"
    static let IDHeaderSectionTableViewCell = "IDHeaderSectionTableViewCell"
    static let IDHeaderTaskTableViewCell = "IDHeaderTaskTableViewCell"
    static let IDTypeTaskTableViewCell = "IDTypeTaskTableViewCell"
    static let IDUserInfoTableViewCell = "IDUserInfoTableViewCell"
    
    //CollectionViewCell ID
    
}

struct UserDefaultsKey {
    
    static let GOOGLE_USER = "Save google user when login successful"
    
}
