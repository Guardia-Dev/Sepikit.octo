//
//  RequestSession.swift
//  Sepikit.octo
//
//  Created by Harry Twan on 04/12/2017.
//  Copyright © 2017 Harry Twan. All rights reserved.
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    func resume()
}

public protocol RequestURLSession {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    func uploadTask(with request: URLRequest, fromData bodyData: Data?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSessionTask: URLSessionDataTaskProtocol { }

extension URLSession: RequestURLSession {
    public func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completion) as URLSessionDataTask
    }
    
    public func uploadTask(with request: URLRequest, fromData bodyData: Data?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return uploadTask(with: request, from: bodyData, completionHandler: completion)
    }
}
