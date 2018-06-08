//
//  UIViewExtension.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 16/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
extension UIView {
    
    func addConstraintsWithFormat(format:String,views:UIView...)
    {
        var viewsDict = [String:UIView]()
        for i in 0..<views.count {
            viewsDict["v\(i)"] = views[i]
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}
