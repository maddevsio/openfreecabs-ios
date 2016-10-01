//
//  ContactsModel.swift
//  openfreecabs
//
//  Created by Pavel and Rus on 9/3/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import Foundation

final class ContactsModel: ResponseObjectSerializable, ResponseCollectionSerializable {
    var type: String
    var contactNumber: String
    
    init() {
        self.type = ""
        self.contactNumber = ""
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard let representation = representation as? [String: Any]
            else { return nil }
        
        self.type = ""
        if (representation["type"] != nil && !(representation["type"] is NSNull)) {
            self.type = representation["type"] as! String
        }
        
        self.contactNumber = ""
        if (representation["contact"] != nil && !(representation["contact"] is NSNull)) {
            self.contactNumber = representation["contact"] as! String
        }
    }
    
    static func collection(response: HTTPURLResponse, representation: Any) -> [ContactsModel] {
        let contactContentArray = representation as! [AnyObject]
        return contactContentArray.map({ContactsModel(response:response, representation: $0)! })
    }
}
