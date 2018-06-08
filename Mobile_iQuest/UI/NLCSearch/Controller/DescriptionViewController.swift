//
//  DescriptionViewController.swift
//  Mobile_iQuest
//
//  Created by Dhanalakshmi on 27/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel?
    
    @IBOutlet weak var confidenceLbl: UILabel?
    @IBOutlet weak var descriptionTextView: UITextView?
    @IBOutlet weak var btnThumbsUp: UIButton!
    @IBOutlet weak var btnThumbsDown: UIButton!
    
    var questions : String?
    var descriptionText: String?
    var confidence: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let KNavigationBarTitle = "Mobile iQuest"
        Utils.setUpNavBar(viewController: self, title: KNavigationBarTitle)
        Utils.setupNavigationTitleLabel(viewController: self, title: KNavigationBarTitle, spacing: 0.0, titleFontSize: 20, color: UIColor.black)
        
        questionLabel?.text = questions
        descriptionTextView?.text = descriptionText
        confidenceLbl?.text = confidence
        setUpViews()
    }
    
    func setUpViews()
    {
        self.view.backgroundColor = UIColor.init(red: 159.0/255.0, green: 214.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        self.descriptionTextView?.layer.cornerRadius = 3.0
        self.descriptionTextView?.font = UIFont.init(name: "Avenir", size: 16.0)
        self.descriptionTextView?.isEditable = false
        self.descriptionTextView?.flashScrollIndicators()
        self.descriptionTextView?.backgroundColor = UIColor.init(red: 159.0/255.0, green: 214.0/255.0, blue: 245.0/255.0, alpha: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnThumbsUpAction(_ sender: Any) {
    }
    
    @IBAction func btnThumbsDownAction(_ sender: Any) {
        let commentPopOver = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "comments") as! CommentsController
        self.addChildViewController(commentPopOver)
        commentPopOver.view.frame = self.view.frame
        self.view.addSubview(commentPopOver.view)
        commentPopOver.didMove(toParentViewController: self)
    }
    
}
