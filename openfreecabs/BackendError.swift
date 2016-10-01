//
//  BackendError.swift
//  taxiclient
//
//  Created by Pavel and Rus on 7/7/16.
//  Copyright © 2016 Namba Taxi. All rights reserved.
//

import Foundation

public enum BackendError: Error {
    case network(error: NSError)
    case dataSerialization(reason: String)
    case jsonSerialization(error: NSError)
    case objectSerialization(reason: String)
    case xmlSerialization(error: NSError)
}
