//
//  IQuestServiceWrapper.swift
//  Mobile-iQuest
//
//  Created by Anand Kumar on 22/02/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation


struct NLCSearchService: MTTURLSessionRequest
{
    typealias ResponseType = NLCSearchServiceResponse
    let baseURL: URL = URL.init(string: "https://cognitiveassistant.in.edst.ibm.com/apiserver/api/trust")!
    let method = HTTPMethod.POST
    let endpoint = ["Trust"]
    let additionalHeaders: [HTTPHeader] = [.contentType(RequestPayload.ContentTypeFormEncodedURL)]
    let payload: RequestPayload
    let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    
    init(){
        
        let postString = "email=dinraman@in.ibm.com&username=dinraman&trustToken=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.ImNvZ2Ftcy50cnVzdGVkLkFQTU1fTUxJVF9DdXN0b20i.HDqSI0MHhJ0B0u_BCskIfTednOUT2pLh0ObSuY0Cw2-jN09yXgU8ECw9Z4_ga-IZ-DW8tMIdH8ebZ_yG7Y2pQQ"
        let jsonData :Data = postString.data(using: String.Encoding.utf8)!
        
        payload = .body(jsonData)
    }
}




struct NLCSearchServiceResponse:MTTJSONResponse {
    init(statusCode: Int, headers: [String : String], json: Any) throws {
        print(json)
        
        guard statusCode == 200 else {
            print(json)
            throw ParsingError.invalidStatusCode
        }
        guard let json = json as? [String: Any] else {
            throw ParsingError.incorrectType
        }
        guard (json["result"] as? String) != nil else {
            throw ParsingError.missingOrInvalidField("result")
        }
        
        
    }
    
}



