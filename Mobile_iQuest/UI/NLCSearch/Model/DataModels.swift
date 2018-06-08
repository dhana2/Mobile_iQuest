//
//  DataModels.swift
//  demo1
//
//  Created by DurgaPrasad-A on 27/02/18.
//  Copyright © 2018 IBM India. All rights reserved.
//

import UIKit

class Message: CustomStringConvertible {
    var text: String?
    var confidence: String?
    var isSender: Bool?
    var isAnswer: Bool?
    
    var description: String  {
        var description = ""
        description += "text: \(String(describing: self.text))"
        return description
    }
}



