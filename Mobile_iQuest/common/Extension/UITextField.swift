//
//  UITextField.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 11/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

extension UITextField{
    func setPadding(){
        let padding = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
}
