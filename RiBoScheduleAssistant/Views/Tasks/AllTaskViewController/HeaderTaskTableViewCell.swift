//
//  HeaderTaskTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/5/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class HeaderTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var countTasksLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}