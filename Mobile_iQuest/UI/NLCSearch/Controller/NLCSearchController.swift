//
//  NLCSearchController.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 02/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import Foundation
import MQChat
import AVFoundation

class NLCSearchController: BaseViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, UITextFieldDelegate, QuestionCellDelegate {
    
    
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var chatCollectionView: MQChatCollectionView!
    @IBOutlet weak var seperatorLine: UIView!
    @IBOutlet weak var askButton: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    var webServiceWrapObject = WebServiceWrap()
    var reachabilty = Reachability()
    var projectId: Int = 0
    var language: String = ""
    var result: [String:Any]?
    var isAnswer: Bool = Bool()
    public var questionArray = [Any]()
    public var answerList = [Any]()
    public let cellId = "CellId"
    public var confidenceArray = [Any]()
    public var topConfidence = NSNumber()
    
    //setup messages insted of  a array
    var messages =  [Message]()
    var delegate: QuestionCellDelegate?
    var global = Global.sharedInstance
    
    //MARK:-  create message's using this function
    private  func createMessageWithText(text:String, confidence: String , isSender:Bool = false) {
        let message = Message()
        message.text = text
        message.confidence = confidence
        message.isSender = isSender
        messages.append(message)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let KNavigationBarTitle = "Mobile iQuest"
        let baseUrl: String = Constant.TRUST_TOKEN_URL
        let bodyString = "email=dhanap77%40in.ibm.com&username=dhanap77&trustToken=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.ImNvZ2Ftcy50cnVzdGVkLkFQTU1fTUxJVF9DdXN0b20i.HDqSI0MHhJ0B0u_BCskIfTednOUT2pLh0ObSuY0Cw2-jN09yXgU8ECw9Z4_ga-IZ-DW8tMIdH8ebZ_yG7Y2pQQ"
        global.getApiToken(baseUrl: baseUrl, bodyStr: bodyString)
        
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        chatCollectionView.backgroundColor = UIColor.init(red: 159.0/255.0, green: 214.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        chatCollectionView.register(MQChatCell.self, forCellWithReuseIdentifier: cellId)
        
        let nib = UINib.init(nibName: "MQQuestionListCell", bundle: Bundle.init(for: MQQuestionListCell.self))
        chatCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
        Utils.setUpNavBar(viewController: self, title: KNavigationBarTitle)
        Utils.setupNavigationTitleLabel(viewController: self, title: KNavigationBarTitle, spacing: 0.0, titleFontSize: 20, color: UIColor.black)
        setupDefaults()
        setupChatTextField()
        setupData()
        setupSubviews()
        inputTextField.setPadding()
        inputTextField.clearButtonMode = .always
        isAnswer = false
        
        addSlideMenuButton()
        addSignInButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpObservers()
    }
    
    func setUpObservers() {
        //MARK:- registering keyboardObservers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    /// Sets the default values for the MessagesViewController
    private func setupDefaults() {
        extendedLayoutIncludesOpaqueBars = true
        chatCollectionView.keyboardDismissMode = .interactive
        chatCollectionView.alwaysBounceVertical = true
    }
    
    /// Adds the messagesCollectionView to the controllers root view.
    private func setupSubviews() {
        view.addSubview(chatCollectionView)
        view.addSubview(containerView)
    }
    
    
    private  func setupChatTextField() {
        containerView.backgroundColor = UIColor.init(red: 216.0/255.0, green: 240.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        containerView.layer.cornerRadius = 5.0
        
        inputTextField.layer.borderWidth = 1.0
        inputTextField.layer.borderColor = UIColor.lightGray.cgColor
        inputTextField.placeholder = "Type your questions here.."
        inputTextField.autocorrectionType = .no
        inputTextField.layer.cornerRadius = 5.0
        inputTextField.backgroundColor = UIColor.white
        //delegate only works with lazy var
        inputTextField.delegate = self
        inputTextField.clearsOnBeginEditing = true
        
        askButton.layer.cornerRadius = 3.5
        askButton.setTitleColor(UIColor.white, for: .normal)
        //sendButton.backgroundColor = UIColor.blue
        let image = UIImage.init(named: "askButton")
        askButton.setBackgroundImage(image, for: .normal)
        askButton.setTitle("Ask", for: .normal)
        askButton.addTarget(self, action: #selector(handleSendBtn), for: .touchUpInside)
        
        //        //MARK:- seperator line above the message text field
        seperatorLine.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        
    }
    
    //MARK:-  handle keyboard
    @objc func handleKeyBoard(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            let keyBoardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let isKeyBoardShowing = notification.name  == NSNotification.Name.UIKeyboardWillShow
            containerBottomConstraint!.constant =  isKeyBoardShowing ? -(keyBoardFrame.height): 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyBoardShowing {
                    self.chatCollectionView.scrollToBottom(animated: true)
                }
            })
        }
    }
    
    
    // MARK:- mock data for setup of chat view
    private  func setupData()  {
        createMessageWithText(text: Constant.WELCOME_MESSAGE, confidence: "" ,isSender: false)
        
    }
    
    //MARK:- Enter Pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        handleSendBtn()
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    //MARK:- on click of send button
    @objc func handleSendBtn() {
        if reachabilty.isConnectedToNetwork() == true {
            print("Internet connection OK")
        }
        else {
            let alertController = UIAlertController(title: "Network Status", message: "There is no data connection", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        if let text = inputTextField.text {
            if   !text.isEmpty {
                createMessageWithText(text: text, confidence: "", isSender: true)
                let baseUrl: String = Constant.NLC_SEARCH_URL
                let bodyString = NSString.init(format: "apiToken=%@&projectId=%d&language=%@&question=%@", global.token,global.projectId,global.language,text)
                getNlcList(baseUrl: baseUrl, bodyStr: bodyString as String)
                activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                activityIndicator.center = chatCollectionView.center
                activityIndicator.hidesWhenStopped = false
                activityIndicator.startAnimating()
                chatCollectionView.addSubview(activityIndicator)
                inputTextField.resignFirstResponder()
                inputTextField.text = ""
                questionArray.removeAll()
            }
            else{
                createMessageWithText(text: Constant.EMPTY_TEXT_MESSAGE, confidence: "", isSender: true)
                inputTextField.resignFirstResponder()
                
            }
            self.chatCollectionView.reloadData()
            if messages.count > 1 {
                self.scrollToBottomOfCollectionView()
            }
            
            
        }
    }
    
    //MARK:- NLC search service call
    func getNlcList(baseUrl: String,bodyStr: String){
        OperationQueue().addOperation {
            self.callWebServiceToGetNLCList(urlStr: baseUrl, bodyString: bodyStr, callBAck: { [weak self](dict) in
                guard let weakSelf = self else {return}
                OperationQueue.main.addOperation({
                    
                    if let dict = dict  as? [String : Any]{
                        let answerValue = dict["top_answer"] as! String
                        weakSelf.topConfidence = dict["top_confidence"] as! NSNumber
                        let confidenceRoundoff = Double(truncating: weakSelf.topConfidence) * 100
                        let confidenceRound = String.init(format: "%.2f", confidenceRoundoff)
                        let removeSpace = answerValue.replacingOccurrences(of: "<p><br/></p></p><p><br/>", with: "")
                        weakSelf.createMessageWithText(text: removeSpace, confidence: confidenceRound , isSender: false)
                        weakSelf.activityIndicator.stopAnimating()
                        weakSelf.activityIndicator.hidesWhenStopped = true
                        weakSelf.chatCollectionView.reloadData()
                        
                        
                        if let answers = dict["answers"] as? [[String : Any]] {
                            
                            for answerDict in answers{
                                let question: String = answerDict["question"] as! String
                                weakSelf.questionArray.append(question)
                                weakSelf.isAnswer = true
                                let answerValue = answerDict["answer"] as! String
                                weakSelf.answerList.append(answerValue)
                                let confidence: NSNumber = answerDict["confidence"] as! NSNumber
                                weakSelf.confidenceArray.append(confidence as Any)
                            }
                            
                            if weakSelf.messages.count > 1{
                                weakSelf.scrollToBottomOfCollectionView()
                            }
                        }
                    }
                    
                    
                })
            })
            
        }
        
    }
    
    func callWebServiceToGetNLCList(urlStr:String,bodyString:String,callBAck:( (Any) ->Void)?){
        
        self.webServiceWrapObject.sendRequestWithPostUrl(urlPath: urlStr, parameters: bodyString, withServiceName: "NLCList", callBack: { (json, serviceName) in
            if serviceName == "NLCList" {
                callBAck?(json)
            }
        })
    }
    
    func scrollToBottomOfCollectionView() {
        
        chatCollectionView.scrollToBottom(animated: true)
        
    }
    
    //MARK:- questionCell tableViewDidSelect delegate
    
    func tableViewDidSelect(indexPath: Int) {
        
        let storyBoard  = UIStoryboard(name: "Main", bundle:nil)
        let describe = storyBoard.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        
        if let questions = questionArray[indexPath] as? String{
            describe.questions = questions
        }
        if let describeText = answerList[indexPath] as? String{
            let removeSpace = describeText.html2String.trim().replacingOccurrences(of: "<p><br/></p></p><p><br/>", with: "")
            describe.descriptionText = removeSpace
        }
        
        if let confidence = confidenceArray[indexPath] as? NSNumber{
            let confidenceRoundoff = Double(truncating: confidence) * 100
            let confidenceRound = String.init(format: "%.2f", confidenceRoundoff)
            describe.confidence = "Watson is \(confidenceRound)% confident about this solution"
        }
        self.navigationController?.pushViewController(describe, animated: true)
        
    }
    
    //MARK:- removeDuplicates in array
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    //MARK:-  deinitialize observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

