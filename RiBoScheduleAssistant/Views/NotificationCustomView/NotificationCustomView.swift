//
//  NotificationCustomView.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 5/23/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import AudioToolbox

protocol NotificationCustomViewDelegate: class {
    
    func didTouchUpInsideView(id: String)
    
}

class NotificationCustomView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    
    weak var delegate: NotificationCustomViewDelegate?
    var id = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        AppDelegate.shared().window!.windowLevel = UIWindowLevelNormal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class var sharedInstance: NotificationCustomView {
        let view = UIView.loadFromNibNamed(nibNamed: "NotificationCustomView") as! NotificationCustomView
        view.frame = CGRect(x: 0, y: -70, width: UIScreen.main.bounds.width, height: 70)
        return view
    }
    
    @IBAction func didTouchUpInsideView(_ sender: UIButton) {
        self.delegate?.didTouchUpInsideView(id: self.id)
    }
    
    func pushNotification(message: String, id: String) {

        let view = NotificationCustomView.sharedInstance
        view.messageLabel.text = message
        AppDelegate.shared().window!.addSubview(view)
        
        UIView.animate(withDuration: 0.3, animations: {
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75)
            view.layoutIfNeeded()
        }) { (check) in
            if check {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                AudioServicesPlayAlertSound(SystemSoundID.init(1016))
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    UIView.animate(withDuration: 0.3, animations: {
                        view.frame = CGRect(x: 0, y: -75, width: UIScreen.main.bounds.width, height: 75)
                    }) { (check) in
                        view.removeFromSuperview()
                    }
                })
            }
        }
    }
    
    func popNotification() {
        UIView.animate(withDuration: 0.3, animations: {
            NotificationCustomView.sharedInstance.frame = CGRect(x: 0, y: -75, width: UIScreen.main.bounds.width, height: 75)
        }) { (check) in
            NotificationCustomView.sharedInstance.removeFromSuperview()
        }
    }
    
    
    
}
