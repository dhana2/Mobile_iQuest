//
//  UIWindow+RootViewController.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 05/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

extension UIWindow{
    func setRootViewController(_ newRootViewController: UIViewController, transition: CATransition? = nil){
        let previousViewController = rootViewController
        if let transition = transition{
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        if UIView.areAnimationsEnabled{
            UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            })
        }else{
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        if let transitionViewClass = NSClassFromString("UITransitionView"){
            for subview in subviews where subview.isKind(of: transitionViewClass){
                subview.removeFromSuperview()
            }
        }
        
        if let PreviousViewController = previousViewController{
            previousViewController?.dismiss(animated: false){
                previousViewController?.view.removeFromSuperview()
            }
        }
    }
}
