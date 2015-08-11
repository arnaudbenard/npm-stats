//
//  LowPassFilter.swift
//  my-npm
//
//  Created by Arnaud Benard on 10/08/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import Foundation


public class LowPassFilter {
    /*
     * time smoothing constant for low-pass filter
     * 0 ≤ alpha ≤ 1 ; a smaller value basically means more smoothing
     * See: http://en.wikipedia.org/wiki/Low-pass_filter#Discrete-time_realization
     */
    var alpha:Double = 0.5
    
    init(alpha: Double) {
        self.alpha = alpha
    }
    
    
    
    public func apply(dataSet: [Double]) -> [Double] {

        var filteredDataSet = dataSet
        for (index, value) in enumerate(dataSet) {
            if index >= 1 {
                let previousFilteredValue = filteredDataSet[index-1]
                // y[i] := y[i-1] + α * (x[i] - y[i-1])
                filteredDataSet[index] = previousFilteredValue + self.alpha * (value - previousFilteredValue)
            }
        }
        
        let average =  self.getAverage(dataSet)
        let averageFiltered = self.getAverage(filteredDataSet)
        let ratio = average / averageFiltered
        
        return filteredDataSet.map() { $0 * ratio }
    }
    
    private func getAverage(data: [Double]) -> Double {
        return data.reduce(0, combine: +) / Double(data.count)
    }
}