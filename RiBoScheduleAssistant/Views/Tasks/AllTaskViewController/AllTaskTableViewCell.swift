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
    func didTouchUpInsideActionButton(cell: AllTaskTableViewCell, sender: UIButton)
    
}

class AllTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    weak var delegate: AllTaskTableViewCellDelegate?
    
    var typeActionButton: ActionButtonType = .none {
        didSet {
            switch typeActionButton {
            case .call:
                self.actionButton.isHidden = false
                self.actionButton.setImage(#imageLiteral(resourceName: "ic_call_task").withRenderingMode(.alwaysTemplate), for: .normal)
            case .email:
                self.actionButton.isHidden = false
                self.actionButton.setImage(#imageLiteral(resourceName: "ic_email_task").withRenderingMode(.alwaysTemplate), for: .normal)
            case .delete:
                self.actionButton.isHidden = false
                self.actionButton.setImage(#imageLiteral(resourceName: "ic_delete_task").withRenderingMode(.alwaysTemplate), for: .normal)
            default:
                self.actionButton.isHidden = true
            }
            self.actionButton.tintColor = App.Color.mainDarkColor
            self.layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchUpInsideDoneButton(_ sender: UIButton) {
        self.delegate?.didTouchUpInsideDoneButton(cell: self, sender: sender)
    }
    
    @IBAction func didTouchUpInsideActionButton(_ sender: UIButton) {
        self.delegate?.didTouchUpInsideActionButton(cell: self, sender: sender)
    }

}
