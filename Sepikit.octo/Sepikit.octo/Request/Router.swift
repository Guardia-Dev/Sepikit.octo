//
//  Router.swift
//  Sepikit.octo
//
//  Created by Harry Twan on 04/12/2017.
//  Copyright © 2017 Harry Twan. All rights reserved.
//

import Foundation

public enum Response<T> {
    case success(T)
    case failure(Error)
}

public enum RestfulMethod: String {
    case GET = "GET"
    case POST = "POST"
}

public enum DataEncoding: Int {
    case url
    case form
    case json
}

public protocol Configuration {
    var apiEndpoint: String { get }
    var accessToken: String? { get }
    var accessTokenFieldName: String { get }
    var errorDomain: String { get }
}

/// The default implement for Configuration Protocol
public extension Configuration {
    var accessTokenFieldName: String {
        return "access_token"
    }
    
    var errorDomain: String {
        return ""
    }
}

/* 
 * URLComponents - URL Structure:
 * http + user:password@ + hostname + :port + /path + ?query + fragme
 * 协议头  用户名:密码        host地址    端口     Router  查询     信息片段
 */
public protocol Router {
    var method: RestfulMethod { get }
    var path: String { get }
    var encoding: DataEncoding { get }
    var params: [String: Any] { get }
    var configuration: Configuration { get }
    
    func urlQuery(_ parameters: [String: Any]) -> [URLQueryItem]?
    func request(_ urlComponents: URLComponents, parameters: [String: Any]) -> URLRequest?
    func request() -> URLRequest?
}

public extension Router {
    public func urlQuery(_ parameters: [String: Any]) -> [URLQueryItem]? {
        guard parameters.count > 0 else { return nil }
        var components: [URLQueryItem] = []
        for key in parameters.keys.sorted(by: <) {
            guard let val = parameters[key] else { continue }
            switch val {
            case let val as String:
                components.append(URLQueryItem(name: key, value: val))
                
            case let valArray as [String]:
                for (index, item) in valArray.enumerated() {
                    components.append(URLQueryItem(name: "\(key)[\(index)]", value: item))
                }
                
            case let valDict as [String: Any]:
                for nestedKey in valDict.keys.sorted(by: <) {
                    guard let val = valDict[key] as? String else { continue }
                    components.append(URLQueryItem(name: "\(key)[\(nestedKey)]", value: val))
                }
                
            default:
                print("Cannot encode object of type \(type(of: val))")
            }
        }
        return components
    }
    
    public func request(_ urlComponents: URLComponents, parameters: [String: Any]) -> URLRequest? {
        var urlComponents = urlComponents
        urlComponents.percentEncodedQuery = urlQuery(parameters)?
            .map({ [$0.name, $0.value ?? ""].joined(separator: "=") })
            .joined(separator: "&")
        guard let url = urlComponents.url else { return nil }
        switch encoding {
        case .url, .json:
            var mutableURLRequest = URLRequest(url: url)
            mutableURLRequest.httpMethod = method.rawValue
            return mutableURLRequest
        case .form:
            let queryData = urlComponents.percentEncodedQuery?.data(using: .utf8)
            // clear the query items as they go into the body
            urlComponents.queryItems = nil
            guard let url = urlComponents.url else { return nil }
            var mutableURLRequest = URLRequest(url: url)
            mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            mutableURLRequest.httpBody = queryData
            mutableURLRequest.httpMethod = method.rawValue
            return mutableURLRequest
        }
    }
    
    public func request() -> URLRequest? {
        let endPoint = configuration.apiEndpoint
        guard let relativeUrl = URL(string: endPoint) else { return nil }
        guard let url = URL(string: path, relativeTo: relativeUrl) else { return nil }
        var parameters = encoding == .json ? [:] : params
        if let accessToken = configuration.accessToken {
            parameters[configuration.accessTokenFieldName] = accessToken as AnyObject?
        }
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            return request(components, parameters: parameters)
        } else {
            return nil
        }
    }
}
