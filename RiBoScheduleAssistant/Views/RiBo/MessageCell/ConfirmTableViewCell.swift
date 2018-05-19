//
//  ConfirmTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

protocol ConfirmTableViewCellDelegate: class {
    func didTouchUpInsideNoButton(_ cell: ConfirmTableViewCell, sender: UIButton)
    func didTouchUpInsideYesButton(_ cell: ConfirmTableViewCell, sender: UIButton)
}

class ConfirmTableViewCell: ReceiverTableViewCell {
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    weak var delegate: ConfirmTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTouchUpInsideNoButton(_ sender: UIButton) {
        self.delegate?.didTouchUpInsideNoButton(self, sender: sender)
    }
    
    @IBAction func didTouchUpInsideYesButton(_ sender: UIButton) {
        self.delegate?.didTouchUpInsideYesButton(self, sender: sender)
    }
}
