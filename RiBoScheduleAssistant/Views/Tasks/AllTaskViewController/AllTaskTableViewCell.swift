//
//  AllTaskTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

protocol AllTaskTableViewCellDelegate: class {
    
    func didTouchUpInsideDoneButton(cell: AllTaskTableViewCell, sender: UIButton)
    
}

class AllTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    weak var delegate: AllTaskTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchUpInsideDoneButton(sender: UIButton) {
        self.delegate?.didTouchUpInsideDoneButton(cell: self, sender: sender)
    }

}
