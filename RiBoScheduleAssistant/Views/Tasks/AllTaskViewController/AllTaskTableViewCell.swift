//
//  AllTaskTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class AllTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
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
