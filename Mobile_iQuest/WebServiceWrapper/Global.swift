//
//  Global.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 11/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation
class Global: NSObject{
    var webServiceWrapObject = WebServiceWrap()
    var token: String = String()
    var projectId: Int = 0
    var language: String = ""
    var result: [String:Any]?
    static let sharedInstance = Global()
    
    //MARK:- apiToken service call
    func getApiToken(baseUrl:String,bodyStr:String){
        OperationQueue().addOperation {
            self.callWebServiceToGetAPIToken(urlStr: baseUrl, bodyString: bodyStr, callBAck: { [weak self](dict) in
                
                guard let weakSelf = self else {return}
                OperationQueue.main.addOperation({
                    
                    if let responseDict = dict as? [String:Any] {
                        let apiToken = responseDict["apiToken"]
                        if let apitoken = apiToken{
                            weakSelf.token =  apitoken as! String
                        }
                    }
                    weakSelf.getProjectList()
                })
            })
        }
    }
    
    //MARK:- project list service call
    func getProjectList() {
        let baseUrl: String = Constant.PROJECT_LIST_URL
        let bodyString = NSString.init(format: "email=%@&apiToken=%@", "dhanap77%40in.ibm.com",token)
        OperationQueue().addOperation {
            self.callWebServiceToGetProjectList(urlStr: baseUrl, bodyString: bodyString as String) { [weak self](projectLists) in
                guard let weakSelf = self else {return}
                
                OperationQueue.main.addOperation({
                    
                    if let dict = projectLists as? [[String : Any]]{
                        if let projectId = dict[1]["projectId"] as? Int {
                            weakSelf.projectId = projectId
                            
                        }
                        
                        if let language = dict[1]["language"]  {
                            weakSelf.language = language as! String
                            
                        }
                    }
                    
                })
            }
        }
    }
    
    
    //MARK:- callback function returns apitoken
    func callWebServiceToGetAPIToken(urlStr:String,bodyString:String,callBAck:( (Any) ->Void)?){
        OperationQueue().addOperation {
            
            self.webServiceWrapObject.sendRequestWithPostUrl(urlPath: urlStr, parameters: bodyString, withServiceName: "TrustToken", callBack: { (json, serviceName) in
                if serviceName == "TrustToken" {
                    callBAck?(json)
                }
            })
        }
    }
    
    //MARK:- callback function returns project list
    func callWebServiceToGetProjectList(urlStr:String,bodyString:String,callBAck:( (Any) ->Void)?){
        OperationQueue().addOperation {
            
            self.webServiceWrapObject.sendRequestWithPostUrl(urlPath: urlStr, parameters: bodyString, withServiceName: "projectList", callBack: { (json, serviceName) in
                if serviceName == "projectList" {
                    callBAck?(json)
                }
            })
        }
    }
    
    
}
