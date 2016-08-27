//
//  ResponseCollectionSerializable.swift
//  taxiclient
//
//  Created by Pavel and Rus on 7/3/15.
//  Copyright (c) 2015 Namba Taxi. All rights reserved.
//

import Foundation
import Alamofire

public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self] {
        var collection = [Self]()
        
        if let representation = representation as? [[String: AnyObject]] {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation) {
                    collection.append(item)
                }
            }
        }
        
        return collection
    }
}

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], BackendError> { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    return .Failure(. ObjectSerialization(reason: "Response collection could not be serialized due to nil response"))
                }
            case .Failure(let error):
                return .Failure(.JSONSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}