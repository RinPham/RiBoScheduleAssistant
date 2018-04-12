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
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        return dateFormatter.string(from: self)
    }
    
    var toDateAndTime2String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        
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
    
    var toDate2String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        
        return dateFormatter.string(from: self)
    }
    
    var toDateAPIFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.string(from: self)
    }
    
    func isSameDayWith(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
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
    
    var toDateTimeMessage: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //2018-09-08T07:00:00Z
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

extension UIView {
    
    func cornerRadius(_ radius: CGFloat, borderWidth width: CGFloat, color: UIColor) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func createShadow(color: UIColor, opacity: Float, width: Int, height: Int, shadowRadius: CGFloat) {
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
        
    }
    
    func createShadow4Sides(shadowSize: CGFloat, shadowOpacity: Float, widthShadow: CGFloat?, heightShadow: CGFloat?) {
        var width: CGFloat {
            if let w = widthShadow {
                return w
            }
            return self.frame.size.width
        }
        var height: CGFloat {
            if let h = heightShadow {
                return h
            }
            return self.frame.size.height
        }
        
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: width + shadowSize,
                                                   height: height + shadowSize))
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath = shadowPath.cgPath
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
