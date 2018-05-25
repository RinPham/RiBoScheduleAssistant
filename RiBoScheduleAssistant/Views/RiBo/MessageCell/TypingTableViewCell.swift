//
//  TypingTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/22/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class TypingTableViewCell: ReceiverTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.showTypingIndicator()
    }

    fileprivate func showTypingIndicator() {
        let jeremyGif = UIImage.gifImageWithName("typing_message2")
        self.messageBackground.image = jeremyGif
    }
}
