//
//  ShowMoreTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

protocol ShowMoreTableViewCellDelegate: class {
    func didTouchUpInsideShowButton(_ cell: ShowMoreTableViewCell, sender: UIButton)
}

class ShowMoreTableViewCell: ReceiverTableViewCell {

    @IBOutlet weak var showButton: UIButton!
    
    var titleButton = "Show"
    
    weak var delegate: ShowMoreTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.showButton.setTitle(self.titleButton, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didTouchUpInsideShowButton(_ sender: UIButton) {
        self.delegate?.didTouchUpInsideShowButton(self, sender: sender)
    }

}
