//
//  MovingAverageFilter.swift
//  my-npm
//
//  Created by Arnaud Benard on 10/08/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import Foundation

public class MovingAverageFilter {

    var period: Int = 8

    
    init(period: Int) {
        self.period = period
    }
    
    
    public func compute(dataSet: [Double]) -> [Double]{
        var result = [Double](count: dataSet.count, repeatedValue: 0.0)
        
        for (index, value) in enumerate(dataSet) {
            result[index] = self.getAverage(dataSet, index: index, period: period)
        }
        return result
    }
    
    private func getAverage(list: [Double], index: Int, period: Int) -> Double {
        var samples: [Double] = [Double] ()
        var count = list.count
        var startBound = index - period
        var endBound = index + period
    
        if startBound < 0 {
            startBound = 0
        }
        
        if endBound > count {
            endBound = count
        }
        
        for i in startBound...endBound {
            if i < count {
                samples.append(list[i])
            }
        }
        
        let sum: Double = samples.reduce(0, combine: +)

        if samples.count > 0 {
            return sum / Double(samples.count)
        } else {
            return list.last!
        }
    }

}