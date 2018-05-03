//
//  UserInfoTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/11/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

protocol UserInfoTableViewCellDelegate: class {
    func didTouchUpInsideLogOutButton(_ cell: UserInfoTableViewCell, sender: UIButton)
}

class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    weak var delegate: UserInfoTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.avatarImageView.cornerRadius(self.avatarImageView.bounds.width/2, borderWidth: 1, color: .darkGray)
    }

    @IBAction func didTouchUpInsideLogOutButton(_ sender: UIButton) {
        self.delegate?.didTouchUpInsideLogOutButton(self, sender: sender)
    }
}
