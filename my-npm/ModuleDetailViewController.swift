//
//  ModuleDetailViewController.swift
//  my-npm
//
//  Created by Arnaud Benard on 28/07/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import UIKit
import Charts

class ModuleDetailViewController: UIViewController, ChartViewDelegate {

    @IBOutlet var ModuleDetailView: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var moduleLabel: UILabel!

    let npm = npmAPI()

    var moduleName: String = ""

    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var days: [String] = [String]()
    var downloads: [Double] = [Double]()

    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    var dataEntries: [ChartDataEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Invalid module name
        if count(moduleName) == 0 {
            return
        }
        
        self.fetchGraphData(moduleName)
        moduleLabel.text = moduleName
        
        chartView.delegate = self;
        chartView.descriptionText = "";
        chartView.noDataTextDescription = "Data will be loaded soon."
        
        setData(months, yAxis: unitsSold)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = moduleName
    }
    
    private func setData(xAxis: [String], yAxis: [Double]) {
        
        for i in 0..<yAxis.count {
            let dataEntry = ChartDataEntry(value: yAxis[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Downloads")
        let chartData = LineChartData(xVals: xAxis, dataSet: chartDataSet)
        chartView.data = chartData
    }
    
    private func fetchGraphData(name: String) {
        npm.fetchRange(name, start: "2015-01-04", end: "2015-08-04") { response, _ in
            for data in response! {
                if let dls = data["downloads"] as? Double, let day = data["day"] as? String {
                    self.downloads.append(dls)
                    self.days.append(day)
                }
            }
            self.setData(self.days, yAxis: self.downloads)
            self.chartView.setNeedsDisplay()
        }
    }
}
