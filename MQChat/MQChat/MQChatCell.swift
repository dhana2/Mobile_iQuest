//
//  ChatCell.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 07/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

public class MQChatCell: UICollectionViewCell {
    
    public let textBubleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    public let confidenceView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    public var messageText: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.init(name: "Avenir", size: 16.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "sample text"
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    public var profileImageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = nil
        return imageView
    }()
    public var profileImageViewRight: UIImageView = {
        let imageViewRight = UIImageView()
        imageViewRight.contentMode = .scaleAspectFill
        imageViewRight.translatesAutoresizingMaskIntoConstraints = false
        imageViewRight.layer.cornerRadius = 20
        imageViewRight.layer.masksToBounds = true
        return imageViewRight
    }()
    public let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"bubble_received")?.resizableImage(withCapInsets: UIEdgeInsetsMake(17, 30, 17, 30),resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let confidenceLabel: UILabel = {
        let confidenceLabel = UILabel()
        confidenceLabel.font = UIFont.init(name: "Avenir", size: 14.0)
        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false
        confidenceLabel.text = "sample text"
        confidenceLabel.numberOfLines = 0
        confidenceLabel.textAlignment = .left
        return confidenceLabel
    }()
    
    public let thumbsUpButton: UIButton = {
        let upButton = UIButton()
        upButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        upButton.setImage(UIImage.init(named: "thumbs-up"), for: .normal)
        upButton.translatesAutoresizingMaskIntoConstraints = false
        return upButton
    }()
    
    public let thumbsDownButton: UIButton = {
        let downButton = UIButton()
        downButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        downButton.setImage(UIImage.init(named: "thumbs-down"), for: .normal)
        downButton.translatesAutoresizingMaskIntoConstraints = false
        return downButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    public func setUpViews() {
        addSubview(textBubleView)
        addSubview(messageText)
        addSubview(profileImageViewLeft)
        addSubview(profileImageViewRight)
        
        textBubleView.addSubview(bubbleImageView)
        textBubleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
        textBubleView.addSubview(confidenceView)
        confidenceView.addSubview(confidenceLabel)
        confidenceView.addSubview(thumbsUpButton)
        confidenceView.addSubview(thumbsDownButton)
        
        //constraints for profileImageView on left side
        addConstraintsWithFormat(format: "H:|[v0(40)]", views: profileImageViewLeft)
        addConstraintsWithFormat(format: "V:[v0(40)]|", views: profileImageViewLeft)
        
        //constraints for profileImageView on right side
        addConstraintsWithFormat(format: "H:[v0(40)]-5-|", views: profileImageViewRight)
        addConstraintsWithFormat(format: "V:[v0(40)]|", views: profileImageViewRight)
        textBubleView.addConstraintsWithFormat(format: "H:|-5-[v0]|", views: confidenceView)
        textBubleView.addConstraintsWithFormat(format: "V:[v0(45)]|", views: confidenceView)
        
        confidenceView.addConstraintsWithFormat(format: "H:|-2-[v0]-5-[v1(30)]-2-[v2(30)]-2-|", views: confidenceLabel, thumbsUpButton,thumbsDownButton)
        confidenceView.addConstraintsWithFormat(format: "V:|[v0]|", views: confidenceLabel)
        confidenceView.addConstraintsWithFormat(format: "V:|[v0]|", views: thumbsUpButton)
        confidenceView.addConstraintsWithFormat(format: "V:|[v0]|", views: thumbsDownButton)
    }
    
}





