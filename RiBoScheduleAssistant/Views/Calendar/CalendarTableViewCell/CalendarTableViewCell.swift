//
//  CalendarTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/21/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var circleIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.circleIconImageView.image = #imageLiteral(resourceName: "blue_circle_icon").withRenderingMode(.alwaysTemplate)
        self.circleIconImageView.tintColor = App.Color.mainDarkColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
