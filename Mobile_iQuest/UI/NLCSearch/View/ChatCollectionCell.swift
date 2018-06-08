//
//  ChatCollectionCell.swift
//  Mobile_iQuest
//
//  Created by Dhanalakshmi on 06/04/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class ChatCollectionCell: UICollectionViewCell {

    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var textBubbleView: UIView!
    @IBOutlet weak var confidenceLable: UILabel!
    @IBOutlet weak var confidenceView: UIView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var profileImageViewRight: UIImageView!
    @IBOutlet weak var profileImageViewLeft: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textBubbleView.layer.cornerRadius = 10
        textBubbleView.layer.masksToBounds = true
        
//        confidenceView.layer.cornerRadius = 10
//        confidenceView.layer.masksToBounds = true
        
        messageText.font = UIFont.init(name: "Avenir", size: 16.0)
        messageText.text = "sample text"
        messageText.isEditable = false
        messageText.backgroundColor = UIColor.clear
        
        profileImageViewLeft.contentMode = .scaleAspectFill
        profileImageViewLeft.layer.cornerRadius = 20
        profileImageViewLeft.layer.masksToBounds = true
        profileImageViewLeft.image = nil
        
        profileImageViewRight.contentMode = .scaleAspectFill
        profileImageViewRight.layer.cornerRadius = 20
        profileImageViewRight.layer.masksToBounds = true
        
        bubbleImageView.image = UIImage(named:"bubble_received")?.resizableImage(withCapInsets: UIEdgeInsetsMake(17, 30, 17, 30),resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
     
//        confidenceLable.font = UIFont.init(name: "Avenir", size: 16.0)
//        confidenceLable.text = "sample text"
//        confidenceLable.backgroundColor = UIColor.red
        
    }
    


}
