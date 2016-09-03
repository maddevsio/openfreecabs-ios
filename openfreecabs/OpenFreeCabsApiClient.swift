//
//  OpenFreeCabsApiClient.swift
//  openfreecabs
//
//  Created by Pavel and Rus on 8/27/16.
//  Copyright © 2016 Mad Devs. All rights reserved.
//

import Alamofire

class OpenFreeCabsApiClient {
    
    static let sharedInstance = OpenFreeCabsApiClient()
    var alamoFireManager : Alamofire.Manager?
    var baseUrl: String = "http://openfreecabs.org/nearest/"
    
    init() {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        self.alamoFireManager = Alamofire.Manager(configuration: configuration)

    }
    
    func getTaxiList(lat: String, lng: String,completionHandler: (Response<TaxiListModel, BackendError>) -> Void) {
        alamoFireManager!.request(.GET, baseUrl + lat + "/" + lng).responseObject(completionHandler)
    }
    
}