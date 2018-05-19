//
//  TaskListTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/15/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
