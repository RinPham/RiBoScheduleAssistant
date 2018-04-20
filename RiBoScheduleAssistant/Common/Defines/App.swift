//
//  App.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/17/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit

struct App {
    
    //Color
    struct Color {
        
        static var mainColor: UIColor {
            return UIColor().hexStringToUIColor(hex: "#00bfa5")
        }
        
        static var mainDarkColor: UIColor {
            return UIColor().hexStringToUIColor(hex: "#008e76")
        }
        
        static var mainLightColor: UIColor {
            return UIColor().hexStringToUIColor(hex: "#5df2d6")
        }
    }
    
    //Font
    struct Font {
        
        
        
    }
    
    //Device
    struct Device {
        
        static var isIphoneX: Bool {
            return UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
        }
        
        static var isIpad: Bool {
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                return true
            default:
                return false
            }
        }
        
    }
}
