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

    @IBOutlet weak var monthCountLabel: UILabel!
    @IBOutlet weak var weekCountLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    
    let npm = npmAPI()
    let blueColor = UIColor(red:0.34, green:0.72, blue:1.00, alpha:1.0)

    var moduleName: String = ""

    var days: [String] = [String]()
    var downloads: [Double] = [Double]()

    var dataEntries: [ChartDataEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Invalid module name
        if count(moduleName) == 0 {
            return
        }
        
        self.fetchGraphData(moduleName)
        self.fetchGlobalStat(moduleName)
        
        chartView.delegate = self;
        chartView.descriptionText = "";
        chartView.noDataTextDescription = "Data will be loaded soon."
        chartView.noDataText = ""
        chartView.infoTextColor = UIColor.whiteColor()
        chartView.drawGridBackgroundEnabled = false // remove gray bg
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = moduleName

    }

    func chartTranslated(chartViewBase: ChartViewBase, dX: CGFloat, dY: CGFloat) {
//        updateRangeLabels()
    }
    
    func chartScaled(chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
//        updateRangeLabels()
    }

    private func updateRangeLabels() {
        let lowestVisibleXIndex = chartView.lowestVisibleXIndex
        let lowestVisibleXLabel = chartView.getXValue(lowestVisibleXIndex)
        let highestVisibleXIndex = chartView.highestVisibleXIndex
        let highestVisibleXLabel = chartView.getXValue(highestVisibleXIndex)

        println("alallala \(lowestVisibleXLabel)")
    }
    
    private func setData(xAxis: [String], yAxis: [Double]) {
        var chartDataY = yAxis
        if yAxis.count > 100 {
//            chartDataY = LowPassFilter(alpha: 1/28).apply(yAxis)
//            chartDataY = MovingAverageFilter(period: 5).compute(yAxis)
        }
        
        for i in 0..<chartDataY.count {
            let dataEntry = ChartDataEntry(value: chartDataY[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Downloads per day")
        
        // line graph style
        chartDataSet.cubicIntensity = 0.05
        chartDataSet.drawCubicEnabled = true
        chartDataSet.drawCircleHoleEnabled = false
        chartDataSet.circleRadius = CGFloat(0.0)
        chartDataSet.setColor(UIColor.whiteColor())
        chartDataSet.highlightEnabled = false
        chartDataSet.lineWidth = 1
        chartDataSet.drawValuesEnabled = false
        
        let chartData = LineChartData(xVals: xAxis, dataSet: chartDataSet)
        chartView.data = chartData
        
        // Hide label on the right
        let yAxisRight = chartView.getAxis(ChartYAxis.AxisDependency.Right)
        yAxisRight.drawLabelsEnabled = false
        yAxisRight.drawGridLinesEnabled = false
        yAxisRight.drawAxisLineEnabled = false
        
        // Format Y axis labels
        let yAxisLeft = chartView.getAxis(ChartYAxis.AxisDependency.Left)
        yAxisLeft.valueFormatter = BigNumberFormatter()
        yAxisLeft.drawGridLinesEnabled = false
        
        chartView.drawBordersEnabled = false

        chartView.leftAxis.customAxisMin = max(0.0, chartView.data!.yMin - 1.0)
        chartView.leftAxis.customAxisMax = chartView.data!.yMax + 1.0
        chartView.leftAxis.labelCount = 6
        chartView.leftAxis.startAtZeroEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.gridColor = UIColor.whiteColor()
        
        let smallFont = UIFont(name: "HelveticaNeue-Light" , size: 10)!
        chartView.leftAxis.labelFont = smallFont
        chartView.leftAxis.labelTextColor = UIColor.whiteColor()
        chartView.leftAxis.drawAxisLineEnabled = false

        chartView.xAxis.labelFont = smallFont
        chartView.xAxis.labelPosition = .Bottom
        chartView.xAxis.gridColor = UIColor.whiteColor()
        chartView.xAxis.labelTextColor = UIColor.whiteColor()
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.drawAxisLineEnabled = false

    }
    
    private func formatDayLabel(day: String) -> String {
        // Format from npm api: YYYY-MM-DD
        let toDateFormatter = NSDateFormatter()
        toDateFormatter.dateFormat = "YYYY-MM-dd"

        // String to date
        let dayDate = toDateFormatter.dateFromString(day)!

        let labelFormatter = NSDateFormatter()
        labelFormatter.dateFormat = "d MMM yyyy"
        let dateFormatted = labelFormatter.stringFromDate(dayDate)
        return dateFormatted
    }
    
    private func fetchGraphData(name: String) {
        npm.fetchRange(name, start: "2013-01-04", end: "2015-08-04") { response, _ in
            for data in response! {
                if let dls = data["downloads"] as? Double, let day = data["day"] as? String {
                    self.downloads.append(dls)
                    self.days.append(self.formatDayLabel(day))
                }
            }
            self.setData(self.days, yAxis: self.downloads)
            self.chartView.setNeedsDisplay()
        }
    }
    
    private func fetchGlobalStat(name: String) {
        // Get ready for the worst code I wrote. Yolo async -> Needs to be refactored with promises ASAP
        npm.fetchModule(name, period: .LastMonth) { response, _ in
            if let downloads = response!["downloads"] as? Double {
                self.monthCountLabel.text = downloads.toDecimalStyle
            }
        }
        
        npm.fetchModule(name, period: .LastWeek) { response, _ in
            if let downloads = response!["downloads"] as? Double {
                self.weekCountLabel.text = downloads.toDecimalStyle
            }
        }
        
        npm.fetchModule(name, period: .LastDay) { response, _ in
            if let downloads = response!["downloads"] as? Double {
                self.dayCountLabel.text = downloads.toDecimalStyle
            }
        }
    }
    
}
