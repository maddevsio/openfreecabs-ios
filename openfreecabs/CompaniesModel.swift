//
//  CompaniesModel.swift
//  openfreecabs
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import Foundation

final class CompaniesModel: ResponseObjectSerializable, ResponseCollectionSerializable {
    var name: String
    var drivers: [DriversModel]
    
    init() {
        self.name = ""
        self.drivers = []
    }
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = ""
        if (representation.valueForKey("name") != nil && !representation.valueForKey("name")!.isEqual(NSNull())) {
            self.name = representation.valueForKey("name") as! String
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