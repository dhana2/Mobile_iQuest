//
//  LoginController.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 19/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var onButtonSelected: UIButton!
    @IBAction func onButtonSelected(_ sender: Any) {
    }
    
    @IBOutlet weak var loginView: UIView!
    @IBAction func onButtonNotSelected(_ sender: Any) {
    }
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        self.navigationItem.hidesBackButton = true
    
    }
    
    func setup() {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginActionBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
