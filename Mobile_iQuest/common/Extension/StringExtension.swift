//
//  StringExtension.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 16/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

extension String {
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
}
