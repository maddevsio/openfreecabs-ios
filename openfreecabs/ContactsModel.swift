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
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.type = ""
        if (representation.valueForKey("type") != nil && !representation.valueForKey("type")!.isEqual(NSNull())) {
            self.type = representation.valueForKey("type") as! String
        }
        self.contactNumber = ""
        if (representation.valueForKey("contact") != nil && !representation.valueForKey("contact")!.isEqual(NSNull())) {
            self.contactNumber = representation.valueForKey("contact") as! String
        }
    }
    
    class func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [ContactsModel] {
        let contactContentArray = representation as! [AnyObject]
        return contactContentArray.map({ContactsModel(response:response, representation: $0)! })
    }
}