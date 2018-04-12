//
//  TypeTaskTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/6/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class TypeTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
