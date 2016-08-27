//
//  BackendError.swift
//  taxiclient
//
//  Created by Pavel and Rus on 7/7/16.
//  Copyright © 2016 Namba Taxi. All rights reserved.
//

import Foundation

public enum BackendError: ErrorType {
    case Network(error: NSError)
    case DataSerialization(reason: String)
    case JSONSerialization(error: NSError)
    case ObjectSerialization(reason: String)
    case XMLSerialization(error: NSError)
}