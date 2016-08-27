//
//  TaxiModel.swift
//  openfreecabs
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import Foundation
final class DriversModel: ResponseObjectSerializable, ResponseCollectionSerializable {
    var lat: Double
    var lng: Double
    
    init() {
        self.lat = 0
        self.lng = 0
    }
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.lat = 0
        if (representation.valueForKey("lat") != nil && !representation.valueForKey("lat")!.isEqual(NSNull())) {
            self.lat = representation.valueForKey("lat") as! Double
        }
        self.lng = 0
        if (representation.valueForKey("lon") != nil && !representation.valueForKey("lon")!.isEqual(NSNull())) {
            self.lng = representation.valueForKey("lon") as! Double
        }
    }
    
    class func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [DriversModel] {
        let taxiArray = representation as! [AnyObject]
        return taxiArray.map({DriversModel(response:response, representation: $0)! })
    }
}