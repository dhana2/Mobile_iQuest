//
//  WebServiceWrapper.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 05/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

class WebServiceWrap : NSObject,URLSessionDelegate{
    
    var serviceString : String = String()
    var baseUrl : String = String()
    
    
    func sendRequestWithPostUrl(urlPath: String, parameters: String, withServiceName: String, callBack:((Any,String)->Void)?){
        serviceString = withServiceName
        guard let urlPath = URL(string: urlPath) else {
            return
        }
        var request = URLRequest(url: urlPath)
        request.setValue("application/x-www-form-urlencode", forHTTPHeaderField: "ContentType")
        request.httpMethod = "POST"
        let bodyData = parameters.data(using: String.Encoding.utf8)
        request.httpBody = bodyData
        
        let config = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.current)
        let task =  session.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse{
                switch httpResponse.statusCode {
                case 200:
                    if let data = data{
                        do{
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            callBack?(json,self.serviceString)
                            
                        }
                        catch{
                            callBack?([],self.serviceString)
                        }
                    }
                    
                default:
                    
                    print("request not successful. HTTP status code: \(httpResponse.statusCode)")
                    
                }
                
            }
            else {
                
                print("Error: Not a valid HTTP response")
                
            }
            
        };task.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.previousFailureCount > 0 {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
        } else {
            
        }
    }
    
}


