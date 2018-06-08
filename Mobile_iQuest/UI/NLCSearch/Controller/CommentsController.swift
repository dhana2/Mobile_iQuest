//
//  CommentsController.swift
//  Mobile_iQuest
//
//  Created by Dhanalakshmi on 03/04/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class CommentsController: UIViewController {
   
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.showAnimate()
        setUpObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != commentsView {
            self.removeAnimate()
        }
    }
    
    
    func setUpObservers() {
        //MARK:- registering keyboardObservers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:-  handle keyboard
    @objc func handleKeyBoard(notification:NSNotification) {
        let prevBottomConstraint = bottomConstraint.constant
        if let userInfo = notification.userInfo {
            let keyBoardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let isKeyBoardShowing = notification.name  == NSNotification.Name.UIKeyboardWillShow
           
            bottomConstraint.constant =  isKeyBoardShowing ? -(keyBoardFrame.height): prevBottomConstraint
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyBoardShowing {
                   print("========= Checking Keyboard  ===========")
                }
            })
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func okAction(_ sender: Any) {
    }
    
}
