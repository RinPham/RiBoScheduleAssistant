//
//  HelperFile.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/3/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

struct Internet {
    
    static var haveInternet: Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return false
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return true
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return true
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return true
        }
        else {
            return false
        }
    }
}


//MARK: - Enum
enum MessageOwner {
    case sender
    case ribo
}

enum MessageType {
    case text
    case typing
}

enum MessageAction: String {
    case none = ""
    case taskAdd = "reminders.add"
    case taskGet = "reminders.get"
    case taskRemove = "reminders.remove"
    case taskRename = "reminders.rename"
    case taskConfirmRemove = "reminders.remove.confirm"
    case eventAdd = "events.add"
    case eventGet = "events.get"
    case eventRemove = "events.remove"
    case eventRename = "events.rename"
    case eventConfirmRemove = "events.remove.confirm"
    case unknown = "input.unknown"
}

enum RepeatType: Int {
    case none
    case daily
    case weekly
    case weekdays
    case weekends
    case monthly
}

enum TaskType: Int {
    case normal
    case call
    case email
}

enum ActionButtonType {
    case delete
    case call
    case email
    case none
}
