//
//  DecimalNumberExtension.swift
//  my-npm
//
//  Created by Arnaud Benard on 09/08/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import Foundation

extension Double {
    var toDecimalStyle:String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter.stringFromNumber(self)!
    }
}