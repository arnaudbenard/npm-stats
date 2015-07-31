//
//  npmAPI.swift
//  my-npm
//
//  Created by Arnaud Benard on 28/07/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import Foundation
import Alamofire

class npmAPI {
    
    func fetchModules(names: [String], callback: (response: NSDictionary?, error: NSError?) -> Void) {
        var modules = ",".join(names)
        var url = "https://api.npmjs.org/downloads/point/last-month/\(modules)"
        Alamofire.request(.GET, url).responseJSON { _, _, json, error in
            if let dict = json as? NSDictionary {
                callback(response: dict, error: nil)
            } else {
                callback(response: nil, error: error)
            }
        }
    }
}
