//
//  UIFontExtension.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 09/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation
import UIKit


extension UIFont {
    
    class func regularSFNSDisplay(size: CGFloat) -> UIFont? {
        return UIFont.init(name: "Avenir Next", size: size)
    }
    
    class func boldSFNSDisplay(size: CGFloat) -> UIFont? {
        return UIFont.init(name: ".HelveticaNeueDeskInterface-Bold", size: size)
    }
}
