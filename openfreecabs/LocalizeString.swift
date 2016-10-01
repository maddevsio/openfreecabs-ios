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
        
        if (UserDefaults.standard.value(forKey: "selectedLang") != nil) {
            lang.append(UserDefaults.standard.value(forKey: "selectedLang") as! String)
        } else {
            lang = Bundle.main.preferredLocalizations
        }
        if let path = Bundle.main.path(forResource: lang[0], ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
}
