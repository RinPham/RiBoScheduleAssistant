//
//  TypingTableViewCell.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/22/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

class TypingTableViewCell: ReceiverTableViewCell {

    @IBOutlet weak var loadingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.showTypingIndicator()
    }

    fileprivate func showTypingIndicator() {
        let jeremyGif = UIImage.gifImageWithName("message_loader")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        imageView.center = self.loadingView.center
        self.loadingView.addSubview(imageView)
    }
}
