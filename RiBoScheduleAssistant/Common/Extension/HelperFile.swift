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
