//
//  CompaniesModel.swift
//  openfreecabs
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit
import SwiftSVG

final class CompaniesModel: ResponseObjectSerializable, ResponseCollectionSerializable {
    var name: String
    var contacts: [ContactsModel]
    var drivers: [DriversModel]
    var icon: UIImage
    
    init() {
        self.name = ""
        self.contacts = []
        self.drivers = []
        self.icon = UIImage()
    }
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = ""
        if (representation.valueForKey("name") != nil && !representation.valueForKey("name")!.isEqual(NSNull())) {
            self.name = representation.valueForKey("name") as! String
        }
        self.icon = UIImage()
        if (representation.valueForKey("icon") != nil && !representation.valueForKey("icon")!.isEqual(NSNull())) {
            let iconUrl = representation.valueForKey("icon") as! String
            print("iconUrl \(iconUrl)")
            if (!iconUrl.isEmpty) {
                let url = NSURL(string: iconUrl) as NSURL!
                if let data = NSData(contentsOfURL: url) as NSData! {
//                    let img : UIImage = UIImage(data: data)!
//                    self.icon = img
                    
                }
            }
        }
        self.contacts = []
        if (representation.valueForKey("contacts") != nil && !representation.valueForKey("contacts")!.isEqual(NSNull())) {
            self.contacts = ContactsModel.collection(response: response, representation: representation.valueForKey("contacts")!)
        }
        
        self.drivers = []
        if (representation.valueForKey("drivers") != nil && !representation.valueForKey("drivers")!.isEqual(NSNull())) {
            self.drivers = DriversModel.collection(response: response, representation: representation.valueForKey("drivers")!)
        }
        
        
    }
    
    class func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [CompaniesModel] {
        let companiesArray = representation as! [AnyObject]
        return companiesArray.map({CompaniesModel(response:response, representation: $0)! })
    }
}