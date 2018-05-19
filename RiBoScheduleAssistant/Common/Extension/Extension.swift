//
//  Extension.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import UserNotifications

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
        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
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
        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        //var result = dateFormatter.string(from: self)
        //result = result.replacingOccurrences(of: "+0700", with: "+0000", options: .literal, range: nil)
        
        return dateFormatter.string(from: self)
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func isSameDayWith(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isTomorrow() -> Bool {
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            return Calendar.current.isDate(self, inSameDayAs: tomorrow)
        }
        return false
    }
}

extension String {
    
    var toDateTime: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //2018-09-08T07:00:00Z
        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
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
    
    func confureNotification(id: String, task: Task) {
        let message = "You have a reminder: \(task.title)."
        let content = UNMutableNotificationContent()
        content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        let dateInfo = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: task.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func configureNotificationUpdateBadge() {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.badge = NSNumber(value: 0)
            var dateInfo = DateComponents()
            dateInfo.hour = 00
            dateInfo.minute = 00
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            
            // Create the request object.
            let request = UNNotificationRequest(identifier: "UpdateNumberBadge", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        } else {
            // Fallback on earlier versions
            // ios 9
            var dateInfo = DateComponents()
            dateInfo.hour = 00
            dateInfo.minute = 00
            let date = Calendar.current.date(from: dateInfo)
            let notification = UILocalNotification()
            notification.fireDate = date
            notification.applicationIconBadgeNumber = 0
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    func checkReachability() -> Bool {
        if currentReachabilityStatus == .reachableViaWiFi {
            print("User is connected to the internet via wifi.")
            return true
        } else if currentReachabilityStatus == .reachableViaWWAN{
            print("User is connected to the internet via WWAN.")
            return true
        } else {
            print("There is no internet connection")
            let alert = UIAlertController(title: "No Internet Connection", message: "Turn on cellular data or use Wi-fi to access data", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
}

extension UIColor {
    
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
