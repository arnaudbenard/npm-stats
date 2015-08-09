//
//  BigNumberFormatter.swift
//  my-npm
//
//  Created by Arnaud Benard on 09/08/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import Foundation

class BigNumberFormatter: NSNumberFormatter {
    
    override func stringFromNumber(number: NSNumber) -> String? {
        
        let formatString = { String(format: "%g", $0) }
        let value = number.doubleValue
        
        if value >= 1_000_000 {
            let dividedBy1M = formatString(value/1_000_000)
            return "\(dividedBy1M)M"
        }
        
        if value >= 1000 {
            let dividedBy1k = formatString(value/1000)
            return "\(dividedBy1k)k"
        }
        
        return formatString(value)
        
    }
}