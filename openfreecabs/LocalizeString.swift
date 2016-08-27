//
//  LocalizeString.swift
//  taxiclient
//
//  Created by Pavel and Rus on 1/28/16.
//  Copyright © 2016 Namba Taxi. All rights reserved.
//

import UIKit

extension String {
    func localized() -> String {
        var lang: [String] = []
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("selectedLang") != nil) {
            lang.append(NSUserDefaults.standardUserDefaults().valueForKey("selectedLang") as! String)
        } else {
            lang = NSBundle.mainBundle().preferredLocalizations
        }
        if let path = NSBundle.mainBundle().pathForResource(lang[0], ofType: "lproj"), bundle = NSBundle(path: path) {
            return bundle.localizedStringForKey(self, value: nil, table: nil)
        }
        return self
    }
}