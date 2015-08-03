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
    
    let endpoint = "https://api.npmjs.org/downloads"
    
    func fetchModules(names: [String], callback: (response: NSDictionary?, error: NSError?) -> Void) {
        let modules = ",".join(names)
        let url = "\(endpoint)/point/last-month/\(modules)"
        Alamofire.request(.GET, url).responseJSON { _, _, json, error in
            if let dict = json as? NSDictionary {
                callback(response: dict, error: nil)
            } else {
                callback(response: nil, error: error)
            }
        }
    }
    
    func fetchRange(name: String, start: String, end: String, callback: (response: NSArray?, error: NSError?) -> Void) {
        let range = "\(start):\(end)"
        let url = "\(endpoint)/range/\(range)/\(name)"
        println("query \(url)")
        Alamofire.request(.GET, url).responseJSON { _, _, json, error in
            println(json?.description)
            if let dict = json as? NSDictionary, downloads = dict["downloads"] as? NSArray {
                callback(response: downloads, error: nil)
            } else {
                callback(response: nil, error: error)
            }
        }
    }
}
