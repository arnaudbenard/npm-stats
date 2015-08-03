//
//  UserSettings.swift
//  my-npm
//
//  Created by Arnaud Benard on 03/08/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import Foundation
import Dollar

class UserSettings {
    var defaults = NSUserDefaults.standardUserDefaults()
    var modules: [NSString] {
        get {
            if let mods = defaults.objectForKey("modules") as? [NSString] {
                return mods
            } else {
                return [NSString]()
            }
        }
    }
    
    func addModule(name: String) {
        var NSName = name as NSString // apparently NSUserDefaults can only persist NSString
        var newValue = [NSString]()
        
        if let mods = defaults.objectForKey("modules") as? [NSString] {
            newValue = mods
        }
        
        newValue += [NSName]
        self.sync(newValue)
    }
    
    func removeModule(name: String) {
        var NSName = name as NSString
        var newValue = [NSString]()

        if let mods = defaults.objectForKey("modules") as? [NSString] {
            newValue = mods.filter() { $0 != name }
        }
        self.sync(newValue)
    }
    
    private func sync(newValue: [NSString]) {
        defaults.setObject($.uniq(newValue), forKey: "modules")
        defaults.synchronize()
    }
}