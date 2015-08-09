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
        
        chartView.delegate = self;
        chartView.noDataTextDescription = "Data will be loaded soon."
        chartView.drawGridBackgroundEnabled = false
        
        let yAxisRight = chartView.getAxis(ChartYAxis.AxisDependency.Right)
        yAxisRight.drawLabelsEnabled = false
        let yAxisLeft = chartView.getAxis(ChartYAxis.AxisDependency.Left)
        yAxisLeft.valueFormatter = BigNumberFormatter()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = moduleName
    }
    
    private func setData(xAxis: [String], yAxis: [Double]) {
        
  
        
        for i in 0..<yAxis.count {
            let dataEntry = ChartDataEntry(value: yAxis[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let blueColor = UIColor(red:0.34, green:0.72, blue:1.00, alpha:1.0)
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Downloads")
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.drawCubicEnabled = true
        chartDataSet.drawCircleHoleEnabled = false
        chartDataSet.circleRadius = CGFloat(0.0)
        chartDataSet.fillAlpha = 65/255.0
        chartDataSet.fillColor = UIColor.redColor()
        chartDataSet.setColor(blueColor)


        
        let chartData = LineChartData(xVals: xAxis, dataSet: chartDataSet)
        chartView.data = chartData
        
        chartView.leftAxis.customAxisMin = max(0.0, chartView.data!.yMin - 1.0)
        chartView.leftAxis.customAxisMax = chartView.data!.yMax + 1.0
        chartView.leftAxis.labelCount = 5
        chartView.leftAxis.startAtZeroEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
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
