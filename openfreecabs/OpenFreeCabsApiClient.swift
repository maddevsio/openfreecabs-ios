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
    var alamoFireManager : Alamofire.SessionManager
    var baseUrl: String = "http://openfreecabs.org/nearest/"
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func getTaxiList(_ lat: String, lng: String,completionHandler: @escaping (_ response: DataResponse<TaxiListModel>) -> Void) {
        let _ = alamoFireManager.request(baseUrl + lat + "/" + lng, method: .get).responseObject(completionHandler: completionHandler)
    }
}
