//
//  HelperFile.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/3/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}


//MARK: - Enum
enum MessageOwner {
    case sender
    case ribo
}

enum MessageType {
    case text
}

enum MessageAction: String {
    case none = ""
    case taskAdd = "reminders.add"
    case taskGet = "reminders.get"
    case taskRemove = "reminders.remove"
    case taskRename = "reminders.rename"
    case eventAdd = "events.add"
    case eventGet = "events.get"
    case eventRemove = "events.remove"
    case eventRename = "events.rename"
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
