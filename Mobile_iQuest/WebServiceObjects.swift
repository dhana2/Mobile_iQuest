//
//  WebServiceObjects.swift
//  Mobile-iQuest
//
//  Created by Anand Kumar on 25/02/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation



#if DEBUG
    private let EnableLogging = true
#else
    private let EnableLogging = false
#endif

// MARK: - Objects

protocol Request {
    associatedtype ResponseType: Response
    
    var method: HTTPMethod { get }
    var headers: [HTTPHeader] { get }
    var baseURL: URL { get }
    var payload: RequestPayload { get }
    var cachePolicy: NSURLRequest.CachePolicy { get }
}

extension Request {
    var cachePolicy: NSURLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
}

protocol Response {
    init(statusCode: Int, headers: [String : String], data: Data) throws
}

protocol JSONResponse: Response {
    init(statusCode: Int, headers: [String : String], json: Any) throws
}

// MARK: - HTTP Method

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

// MARK: - HTTP Header

public enum HTTPHeader {
    case authorization(String)
    case accept(String)
    case contentType(String)
    case acceptLanguage(String)
    case contentLanguage(String)
    case ifModifiedSince(String)
    case custom(name: String, value: String)
}

extension HTTPHeader {
    static let Key_ContentType = "Content-Type"
    static let Key_ContentLanguage = "Content-Language"
    static let Key_LastModified = "Last-Modified"
}

// MARK: - Request payload

public enum RequestPayload {
    case none
    case queryParameters([(name: String, value: Any)])
    case body(Data)
    
    fileprivate func contentTypeHeaders(_ type: String) -> [HTTPHeader] {
        // Returns array for easy appending
        if case .body(_) = self {
            return [.contentType(type)]
        } else {
            return []
        }
    }
    
    public static let ContentTypeJSON = "application/json"
    public static let ContentTypeFormEncodedURL = "application/x-www-form-urlencoded"
    
    public static func JSONBody(_ json: Any, options: JSONSerialization.WritingOptions = []) throws -> RequestPayload {
        return .body(try JSONSerialization.data(withJSONObject: json, options: options))
    }
}

// MARK: - Result wrapper

public enum WebServiceResult<R> {
    case success(R)
    case responseFailure(statusCode: Int, headers: [String : String], Error)
    case networkFailure(Error)
    
    /// To convert from one failed result type to another.
    /// This can be used for passing errors through multiple completion handlers.
    internal init<T>(nonSuccessful result: WebServiceResult<T>) {
        switch result {
        case .success(_):
            fatalError("Can only convert non-successful results")
        case let .responseFailure(statusCode, headers, error):
            self = .responseFailure(statusCode: statusCode, headers: headers, error)
        case let .networkFailure(error):
            self = .networkFailure(error)
        }
    }
}

/// MARK: - Errors

public enum ParsingError: Error {
    case invalidStatusCode
    case invalidContentType(actual: String?, expected: String)
    case invalidData(Error?)
    case incorrectType
    case missingOrInvalidField(String)
}

// MARK: - Headers

private extension HTTPHeader {
    
    var header: (name: String, value: String) {
        switch self {
        case let .authorization(value):
            print("Authorization\(value)")
            return ("Authorization", value)
            
        case let .accept(value):
            print("Accept\(value)")
            
            return ("Accept", value)
        case let .acceptLanguage(value):
            print("Accept-Language\(value)")
            return ("Accept-Language", value)
        case let .contentType(value):
            print("type(of: self).Key_ContentType\(type(of: self).Key_ContentType)\(value)")
            return (type(of: self).Key_ContentType, value)
        case let .contentLanguage(value):
            print("contentType\(value)")
            print("type(of: self).Key_ContentLanguage\(type(of: self).Key_ContentLanguage)\(value)")
            return (type(of: self).Key_ContentLanguage, value)
            
        case let .ifModifiedSince(date):
            print("If-Modified-Since\(date)")
            return ("If-Modified-Since", date)
        case let .custom(header):
            return header
        }
    }
}

// MARK: - Request creation

private extension Request {
    /// - Returns: The class name of the description
    var requestDescription: String {
        return String(describing: self)
    }
}

extension Request {
    
    static func buildURL(_ baseURL: URL) -> URL {
        let url = baseURL
        
        
        return url
    }
    
    func createURLRequest() -> URLRequest {
        let request = NSMutableURLRequest(url: type(of: self).buildURL(baseURL))
        request.cachePolicy = cachePolicy
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        headers.setOnRequest(request)
        payload.setOnRequest(request)
        print("request,cachePolicy,httpMethod\(request,cachePolicy,headers,payload)")
        
        return request as URLRequest
    }
}

extension Sequence where Self.Iterator.Element == HTTPHeader {
    
    func setOnRequest(_ request: NSMutableURLRequest) {
        for h in self {
            let keyValue = h.header
            request.addValue(keyValue.value, forHTTPHeaderField: keyValue.name)
            print("request\(request)")
        }
    }
}

extension RequestPayload {
    
    func setOnRequest(_ request: NSMutableURLRequest) {
        switch self {
        case let .queryParameters(params) where !params.isEmpty:
            var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            components?.queryItems = type(of: self).createQueryItems(params)
            request.url = components?.url
            print("request.url\(String(describing: request.url))")
            
        case let .body(data):
            request.httpBody = data
            print(" request.httpBody\(String(describing:  request.httpBody))")
            
        default:
            break
        }
    }
    
    static func createQueryItems(_ parameters: [(name: String, value: Any)]) -> [URLQueryItem] {
        
        func stringifyParameterValue(_ v: Any) -> String {
            struct ValueTypes {
                // Available boolean types so you can check if the type of NSNumbers is a boolean
                static let BoolTypes = [NSNumber(value: true as Bool),  NSNumber(value: false as Bool)].map { $0.objCType }
            }
            
            switch v {
            case let bool as NSNumber where ValueTypes.BoolTypes.contains(bool.objCType):
                return bool.boolValue ? "true" : "false"
            case let string as String:
                print("string\(string)")
                return string
            case is NSArray:
                fatalError("Arrays not allowed")
            default:
                print("String(describing: v)\(String(describing: v))")
                return String(describing: v)
            }
        }
        
        var items = [URLQueryItem]()
        items.reserveCapacity(parameters.count)
        for (k, v) in parameters {
            if let v = v as? NSArray {
                // Convert to k=v[0]&k=v[1]...
                items.append(contentsOf: v.map { URLQueryItem(name: k, value: stringifyParameterValue($0)) })
                print("items\(items))")
            } else {
                items.append(URLQueryItem(name: k, value: stringifyParameterValue(v)))
                print("items\(items))")
            }
        }
        
        return items
    }
}

// MARK: - Logging

func requestResultLog<R: Request>(_ request: R, _ result: WebServiceResult<R.ResponseType>) {
    if EnableLogging {
       // log("Request \(request.requestDescription) completed with result: \(result)")
    }
}

// MARK: - Response creation

extension JSONResponse {
    /// Converts to JSON object with the `NSJSONReadingOptions.AllowFragments` option set.
    init(statusCode: Int, headers: [String : String], data: Data) throws {
        try self.init(statusCode: statusCode, headers: headers, json: try JSONFromResponse(statusCode: statusCode, headers: headers, data: data))
    }
}

func JSONFromResponse(statusCode: Int, headers: [String : String], data: Data) throws -> Any {
    
    // Check type
    let actualContentType = headers[HTTPHeader.Key_ContentType]
    
    // Parse JSON
    let json: Any
    do {
        json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    } catch {
        // Allow JSON failures with 0 data if we're in the 3xx status range as this means something else
        if data.count == 0 && (300...399).contains(statusCode) {
            return NSNull()
        } else {
            guard let contentType = actualContentType, contentType == RequestPayload.ContentTypeJSON else {
                throw ParsingError.invalidContentType(actual: actualContentType, expected: RequestPayload.ContentTypeJSON)
            }
            throw ParsingError.invalidData(error)
        }
    }
    
    // Remove NSNulls
    func removeNulls(_ someJSON: Any) -> Any? {
        switch someJSON {
        case is NSNull:
            return nil
            
        case let array as [AnyObject]:
            return array.flatMap(removeNulls)
            
        case let dictionary as [String : AnyObject]:
            var result = [String : Any](minimumCapacity: dictionary.count)
            for (k, v) in dictionary {
                if let nonNullV = removeNulls(v) {
                    result[k] = nonNullV
                }
            }
            return result
            
        default:
            return someJSON
        }
    }
    guard let jsonWithoutNulls = removeNulls(json) else {
        throw ParsingError.incorrectType
    }
    return jsonWithoutNulls
}

/// Converts a badly typed dictionary to string based key, value pairs.
func covertResponseHeaders(_ responseHeaders: [AnyHashable: Any]?) -> [String : String] {
    
    guard let responseHeaders = responseHeaders else {
        return [String : String]()
    }
    
    var headers: [String : String]
    if let allHeaderFields = responseHeaders as? [String : String] {
        headers = allHeaderFields
    } else {
        func convertToString(_ value: Any) -> String {
            return (value as? String) ?? String(describing: value)
        }
        headers = [String : String](minimumCapacity: responseHeaders.count)
        // Try to convert manually
        for (k, v) in responseHeaders {
            headers[convertToString(k)] = convertToString(v)
        }
    }
    return headers
}

// MARK: - URL Session based requests

protocol URLSessionRequest: Request {
}

extension URLSessionRequest {
    
    func executeWithSession(_ session: Foundation.URLSession, completion: @escaping (WebServiceResult<ResponseType>) -> Void) -> URLSessionDataTask {
        let request = createURLRequest()
        print("session request\(request)")
        let parser = type(of: self).parseResponse(self)
        print("session parser\(parser)")
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let parsingBlock: () -> Void = {
                let result = parser(data, response, error)

                print("session result\(result)")
                DispatchQueue.main.sync
                    {
                    completion(result)
                }
            }
            
            let parsingQueue = DispatchQueue.global(qos: .background)
            let executeSync: (_ block: () -> Void) -> Void = { block in parsingQueue.sync { block() } }
            let executeAsync: (_ block: @escaping () -> Void) -> Void = { block in parsingQueue.async(execute: block) }
            
            if session.delegateQueue.underlyingQueue === parsingQueue {
                executeAsync(parsingBlock)
            } else {
                executeSync(parsingBlock)
            }
        }
        return executeTask(task)
    }
    
 
    fileprivate func executeTask<T: URLSessionTask>(_ task: T) -> T {
        task.taskDescription = requestDescription
        task.resume()
        return task
    }
    
    fileprivate static func parseResponse(_ request: Self) -> (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> WebServiceResult<ResponseType> {
        return { (data, response, error) in
            let result = parseResponse(data, response: response, error: error)
            requestResultLog(request, result)
            return result
        }
    }
}

extension Request {
    
    static func parseResponse(_ data: Data?, response: URLResponse?, error: Error?) -> WebServiceResult<ResponseType> {
        return ResponseType.parseResponse(data, response: response, error: error)
    }
}

extension Response {
    
    static func parseResponse(_ data: Data?, response: URLResponse?, error: Error?) -> WebServiceResult<Self> {
        
        let httpResponse = response as! HTTPURLResponse?
        
        if let error = error {
            guard let response = httpResponse else {
                return .networkFailure(error)
            }
            return .responseFailure(statusCode: response.statusCode, headers: covertResponseHeaders(response.allHeaderFields), error)
        }
        
        guard let response = httpResponse else {
            fatalError("No error or HTTP response for response: \(self)")
        }
        guard let data = data else {
            fatalError("No error or data for response: \(self)")
        }
        let headers = covertResponseHeaders(response.allHeaderFields)
        
        do {
            // Convert to object
            let object = try Self(statusCode: response.statusCode, headers: headers, data: data)
            return .success(object)
        } catch {
            return .responseFailure(statusCode: response.statusCode, headers: headers, error)
        }
    }
}

// MARK: - Display extensions

extension HTTPHeader: CustomStringConvertible {
    
    public var description: String {
        let header = self.header
        return "\(header.name): \(header.value)"
    }
}

extension RequestPayload: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "<>"
            
        case let .body(data):
            return String(describing: data)
            
        case let .queryParameters(parameters):
            return String(describing: RequestPayload.createQueryItems(parameters))
        }
    }
}

extension WebServiceResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .success(value):
            return "Success(\(value))"
            
        case let .responseFailure(statusCode, headers, error):
            return "ResponseFailure(statusCode: \(statusCode), headers: \(headers), error: \(error))"
            
        case let .networkFailure(error):
            return "NetworkFailure(\(error))"
        }
    }
}

extension ParsingError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidStatusCode:
            return "InvalidStatusCode"
            
        case let .invalidContentType(actual, expected):
            return "InvalidContentType(actual: \(String(describing: actual)), expected: \(expected))"
            
        case let .invalidData(data):
            return "InvalidData(\(String(describing: data)))"
            
        case .incorrectType:
            return "IncorrectType"
            
        case let .missingOrInvalidField(fieldName):
            return "MissingOrInvalidField(field: \(fieldName))"
        }
    }
}



