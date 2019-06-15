//
//  ChartViewController.swift
//  QRCoder
//
//  Created by Frank Cheng on 2019/6/14.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import Charts

class CustomDateFormatter: NumberFormatter {
    override func string(from number: NSNumber) -> String? {
        let date =  Date(timeIntervalSinceNow: 3600*24*Double(truncating: number))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: date)
    }
}

class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let start = 1
        let count = 40
        let range = UInt32(10)
        
        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        chartView.animate(yAxisDuration: 0.5)
        chartView.maxVisibleCount = 10
        chartView.xAxis.labelCount = 5
        chartView.xAxis.labelWidth = 10
        chartView.xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        let dateFormatter = CustomDateFormatter()
        chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: dateFormatter)
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(entries: yVals, label: "最近两周的访问")
        set1.colors = ChartColorTemplates.material()
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        chartView.data = data
        
        chartView.setVisibleXRangeMaximum(5)
        chartView.moveViewToX(data.xMax)
        chartView.notifyDataSetChanged()
    }
}
