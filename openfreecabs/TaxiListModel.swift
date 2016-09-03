//
//  TaxiListModel.swift
//  openfreecabs
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import UIKit

final class TaxiListModel: ResponseObjectSerializable, ResponseCollectionSerializable {
    var success: Bool
    var companies: [CompaniesModel]
    
    init() {
        self.success = false
        self.companies = []
    }
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.success = false
        if (representation.valueForKey("success") != nil && !representation.valueForKey("success")!.isEqual(NSNull())) {
            self.success = representation.valueForKey("success") as! Bool
        }
        
        self.companies = []
        if (representation.valueForKey("companies") != nil && !representation.valueForKey("companies")!.isEqual(NSNull())) {
            self.companies = CompaniesModel.collection(response: response, representation: representation.valueForKey("companies")!)
        }
    }
}