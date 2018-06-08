 //
//  WebServiceInterface.swift
//  Mobile-iQuest
//
//  Created by Anand Kumar on 25/02/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

private let DefaultHTTPHeaders: [String: String] = {
    // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
    let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
    
    // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
    let acceptLanguage: String = {
        var components: [String] = []
        let upperRange = min(Locale.preferredLanguages.count, 6)
        for (index, languageCode) in Locale.preferredLanguages[0..<upperRange].enumerated() {
            let q = 1.0 - (Double(index) * 0.1)
            components.append("\(languageCode);q=\(q)")
        }
        return components.joined(separator: ", ")
    }()
    
    // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
    let userAgent: String? = {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            let os = ProcessInfo().operatingSystemVersionString
            
            var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
            let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
            
            if CFStringTransform(mutableUserAgent, nil, transform, false) {
                return mutableUserAgent as String
            }
        }
        return nil
    }()
    
    var headers = [
        "Accept-Encoding": acceptEncoding,
        "Accept-Language": acceptLanguage
    ]
    if let userAgent = userAgent {
        headers["User-Agent"] = userAgent
    }
    return headers
}()


let URLSession: Foundation.URLSession = {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = DefaultHTTPHeaders
    return Foundation.URLSession(configuration: config, delegate: URLSessionDelegate(), delegateQueue: nil)
}()



protocol MTTURLSessionRequest: BaseRequest, URLSessionRequest {
    
}

extension MTTURLSessionRequest {
    
    static var BaseURL: URL
    {
        return BaseURL
    }
    
    func execute(_ completion: @escaping (WebServiceResult<ResponseType>) -> Void) {
        _ = executeWithSession(URLSession, completion: completion)
       
    }
  
    
}

// MARK: - URL Session constants

private class URLSessionDelegate: NSObject, Foundation.URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        
        if challenge.previousFailureCount > 0 {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        }
        else if let serverTrust = challenge.protectionSpace.serverTrust
        {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
        }
        else
        {
            print("unknown state. error: \(String(describing: challenge.error))")
            // do something w/ completionHandler here
        }
}
 }



protocol BaseRequest: Request where ResponseType: MTTResponse {
    static var BaseURL: URL { get }
    
    
    var additionalHeaders: [HTTPHeader] { get }
    
    var endpoint: [String] { get }
    
    /// Executes the response
    func execute(_ completion: @escaping (WebServiceResult<ResponseType>) -> Void)
    
}

extension BaseRequest {
    
    var baseURL: URL {
        return type(of: self).BaseURL
    }
    
    /// Concatenates the default headers and `additionalHeaders`.
    var headers: [HTTPHeader] {
        var all = [HTTPHeader]()
        
     
        all.append(contentsOf: additionalHeaders)
        print("all\(all)")
        return all
    }
    
    /// Defaults to no additional headers.
    var additionalHeaders: [HTTPHeader] {
        return []
    }
    
    /// Defaults to .None
    var payload: RequestPayload {
        return .none
    }
}

// MARK: - Responses

enum MTTError: Error {
    case invalidResponse(statusCode: Int)
    case statusError(statusCode: Int, errorCode: Int, message: String)
    case businessError(statusCode: Int, errorCode: Int, message: String)
}

/// All responses that the Maersk application consumes should use this base protocol.
protocol MTTResponse: Response {
}

/// All data responses that the Maersk application consumes should use this base protocol.
protocol MTTJSONResponse: JSONResponse, MTTResponse {
}

/// All content responses (HTML, etc.) that the Maersk application consumes should use this base protocol.
protocol MTTRawResponse: MTTResponse {
}

extension MTTError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .invalidResponse(statusCode):
            return "InvalidResponse(statusCode: \(statusCode))"
        case let .statusError(statusCode, errorCode, message):
            return "StatusError(statusCode: \(statusCode), errorCode: \(errorCode), message: \(message))"
        case let .businessError(statusCode, errorCode, message):
            return "BusinessError(statusCode: \(statusCode), errorCode: \(errorCode), message: \(message))"
        }
    }
}
