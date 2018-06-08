//
//  Utils.swift
//  Mobile_iQuest
//
//  Created by Dhanalakshmi on 23/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static let KNavigationBarTitle: String = "Mobile iQuest"
    class func setNavigationItems(viewController: UIViewController, rightButtons: [UIBarButtonItem], leftButtons: [UIBarButtonItem]){
        viewController.navigationController?.navigationItem.hidesBackButton = true
        viewController.navigationController?.navigationBar.topItem?.rightBarButtonItems = rightButtons
        viewController.navigationController?.navigationBar.topItem?.leftBarButtonItems = leftButtons
    }
    class func setUpNavBar(viewController: UIViewController, title: String){
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.clear]
    }
    
    class func setupNavigationTitleLabel(viewController: UIViewController, title: String, spacing: CFloat, titleFontSize: CGFloat, color: UIColor){
        let titleLabel = UILabel()
        let attributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "HelveticaNeue", size: titleFontSize)!, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): color, NSAttributedStringKey(rawValue: NSAttributedStringKey.kern.rawValue) : spacing] as [NSAttributedStringKey : Any]
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        titleLabel.sizeToFit()
        viewController.navigationController?.navigationBar.topItem?.titleView = titleLabel
    }
    
    
    
}
