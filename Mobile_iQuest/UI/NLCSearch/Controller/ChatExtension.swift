//
//  ChatExtension.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 07/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import MQChat
extension NLCSearchController{
    
    //MARK:- collection view datasource and delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return messages.count
        case 1:
            if questionArray.count != 0{
                return 1
            }
            return 0
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell =  chatCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MQChatCell
            print(indexPath.row)
            if let message = messages[indexPath.row].text, let isSender = messages[indexPath.row].isSender , let confidence = messages[indexPath.row].confidence{
                
                cell.messageText.text = message.html2String.trim()
                cell.thumbsDownButton.addTarget(self, action: #selector(NLCSearchController.btnThumbsDownAction(_:)), for: .touchUpInside)
                //message box size controlled here max width = 250
                let size = CGSize(width: 250, height: 2000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedFrame = NSString(string: message).boundingRect(with: size , options: options, attributes: [NSAttributedStringKey.font : UIFont.init(name: "Avenir", size: 16.0)!], context: nil)
                
                //left side chat
                if !isSender {
                    if indexPath.row == 0{
                        cell.confidenceView.alpha = 0
                        cell.messageText.frame = CGRect(x: 40 + 8, y: 0, width: estimatedFrame.width + 16 , height: estimatedFrame.height  + 20)
                        
                    }
                    else {
                        cell.confidenceView.alpha = 1
                        cell.messageText.frame = CGRect(x: 40 + 8, y: 0, width: estimatedFrame.width + 16 , height: estimatedFrame.height - 50 + 20 )
                        cell.confidenceView.isHidden = false
                        cell.confidenceLabel.text = "Watson is \(confidence)% confident about this solution"
                    }
                    cell.textBubleView.frame = CGRect(x: 40, y: 0, width: estimatedFrame.width + 16 + 8 , height: estimatedFrame.height + 20)
                    
                    cell.bubbleImageView.image = UIImage(named:"bubble_received")?.resizableImage(withCapInsets: UIEdgeInsetsMake(17, 30, 17, 30),resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                    cell.bubbleImageView.tintColor = UIColor(white: 0.90, alpha: 1)
                    cell.profileImageViewRight.isHidden = true
                    cell.profileImageViewLeft.isHidden = false
                    cell.profileImageViewLeft.image = UIImage(named:"watson_avatar")
                    cell.messageText.textColor = UIColor.black
                    
                    
                }
                    //right  side chat
                else {
                    cell.messageText.frame = CGRect(x: view.frame.width - estimatedFrame.width -  40 - 25, y: 0, width: estimatedFrame.width + 16 , height: estimatedFrame.height + 20)
                    cell.textBubleView.frame = CGRect(x: view.frame.width - estimatedFrame.width -  40 - 25 , y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                    cell.profileImageViewLeft.isHidden = true
                    cell.profileImageViewRight.isHidden = false
                    cell.profileImageViewRight.image = UIImage(named:"icon-Avatar")
                    cell.messageText.textColor = UIColor.black
                    cell.bubbleImageView.image = UIImage(named:"bubble_sent")?.resizableImage(withCapInsets: UIEdgeInsetsMake(17, 30, 17, 30),resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
                    cell.bubbleImageView.tintColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
                    cell.confidenceView.isHidden = true
                    
                }
            }
            
            return cell
        case 1:
            
            let cell = chatCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MQQuestionListCell
            if questionArray.count != 0{
                let questionDuplicates = removeDuplicates(array: questionArray as! [String])
                cell.questionList = questionDuplicates
                cell.delegate = self
                cell.tableView?.reloadData()
                
            }
            else{
                cell.tableView?.isHidden = true
            }
            return cell
        default:
            let cell = UICollectionViewCell(frame: .zero)
            return cell
        }
        
    }
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            if let message = messages[indexPath.row].text {
                let size = CGSize(width: 250, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedFrame = NSString(string: message).boundingRect(with: size , options: options, attributes: [NSAttributedStringKey.font : UIFont.init(name: "Avenir", size: 16.0)!], context: nil)
                return CGSize(width: view.frame.width , height: estimatedFrame.height + 30)
            }
        }
        else if indexPath.section == 1{
            let size = CGSize(width: 250, height: 300)
            let estimatedFrame = CGRect(x: 40 + 8, y: 0, width: size.width + 16 , height: size.height + 20)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 500)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 2, 8, 0)
        
    }
    
    func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            return layoutAttributes
    }
    
    func addSignInButton(){
        let btnShowSignIn = UIButton(type: UIButtonType.system)
        btnShowSignIn.setImage(UIImage.init(named: "signIn"), for: .normal)
        btnShowSignIn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowSignIn.addTarget(self, action: #selector(NLCSearchController.onSiginButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowSignIn)
        self.navigationItem.rightBarButtonItem = customBarItem;
    }
    
    //MARK:- NavigationBar OnSigninClicked
    @objc func onSiginButtonPressed(_ sender: UIButton){
        let storyBoard  = UIStoryboard(name: "Login", bundle:nil)
        let signIn = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    
    //MARK:- onClick thumbsDown
    @objc func btnThumbsDownAction(_ sender: UIButton) {
        print("button pressed")
        let commentPopOver = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "comments") as! CommentsController
        self.addChildViewController(commentPopOver)
        commentPopOver.view.frame = self.view.frame
        self.view.addSubview(commentPopOver.view)
        commentPopOver.didMove(toParentViewController: self)
        
    }
}
