//
//  Extension.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

extension Date {
    
    var toDateAndTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        return dateFormatter.string(from: self)
    }
    
    var toTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
    
    var toDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    var toDateAPIFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    var toDateTime: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //2018-09-08T07:00:00Z
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return Date()
    }
    
    var toDateTimeEvent: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //2018-03-06T14:51:24.000Z
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"//"2018-03-01"
            if let date = dateFormatter.date(from: self) {
                return date
            }
        }
        return Date()
    }
}

extension UIViewController {
    
    public func showAlert(title: String?, message: String?, option: UIAlertControllerStyle, btnCancel: UIAlertAction, buttonNormal: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: option)
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            if option == .actionSheet {
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height), size: self.view.frame.size)
                alert.popoverPresentationController?.permittedArrowDirections = .up
            }
        default:
            break
        }
        alert.addAction(btnCancel)
        for button in buttonNormal {
            alert.addAction(button)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
