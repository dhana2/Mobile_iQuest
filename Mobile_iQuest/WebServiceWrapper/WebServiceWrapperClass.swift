//
//  WebServiceWrapperClass.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 02/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation


class WebServiceWrapper: NSObject, URLSessionDelegate
{

    func getIQuestResponse(iquestModal:IQuestModal, completionHandler:@escaping ((AnyObject?,Error?)-> Void) )
    {
        var bodyString: String = ""
        var request: URLRequest = URLRequest.init(url: URL.init(string: "https://syntaxdb.com/ref/swift/getters-setters")!)
        switch iquestModal._endpointType {
        case "trustToken":
            guard let url = URL.init(string: iquestModal._token._baseUrl) else {return}
            request = URLRequest.init(url: url)
            request.httpMethod = "POST"
            bodyString = "email=" + iquestModal._token._email + "&username=" + iquestModal._token._userName + "&trustToken=" + iquestModal._token._trustToken
        case "projectList":
            guard let url = URL.init(string: iquestModal._projectList._baseUrl) else {return}
            request = URLRequest.init(url: url)
            request.httpMethod = "POST"
            bodyString = "apiToken=" + iquestModal._projectList._apiToken + "&email=" + iquestModal._projectList._email
        default: break
            
        }
        let bodyData = bodyString.data(using: String.Encoding.utf8)
        request.httpBody = bodyData
        let config = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.current)
        let task =  session.dataTask(with: request) { (data, response, error) in
            if let response = response
            {
                print(response)
            }
            if let data = data
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completionHandler(json as AnyObject,nil)
                }
                catch
                {
                    completionHandler(nil,error)
                }
            }
            
        };task.resume()
      
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.previousFailureCount > 0 {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
        } else {
            print("unknown state. error: \(String(describing: challenge.error))")
            // do something w/ completionHandler here
        }
    }

}
