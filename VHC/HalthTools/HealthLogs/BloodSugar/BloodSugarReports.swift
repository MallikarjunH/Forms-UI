//
//  BloodSugarReports.swift
//  VidalHealth
//
//  Created by mallikarjun on 17/07/19.
//  Copyright © 2019 Clean Bill of Health Private Limited. All rights reserved.
//

import UIKit
import Charts

class BloodSugarReports: UIViewController, UITableViewDataSource, UITableViewDelegate,ChartViewDelegate {

    var dataEntries: [ChartDataEntry] = []
   // let months = ["Jan" , "Feb", "Mar", "Apr", "May", "June", "July", "August", "Sept", "Oct", "Nov", "Dec"]
   // let unitsSold = [24.0,43.0,56.0,23.0,56.0,68.0,48.0,120.0,41.0,34.0,55.9,12.0]
    
    var selectedOption = ""
    
    var months = [String]()
    var unitsSold = [Double]()
    
    var upperLimitValue = 0.0
    var lowerLimitValue = 0.0
    var axisMinValue = 0.0
    var axixMaxvalue = 0.0
    
    @IBOutlet weak var mainTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

         selectedOption = "fasting"
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLogRecords(notification:)), name: Notification.Name("refreshChartDataValues1"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    //MARK: TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BloodSugarReportsCell1Id", for: indexPath) as! BloodSugarReportsCell1
            // setChart(dataPoints: months, values: unitsSold)
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            
            unitsSold = []
            
            if selectedOption == "fasting"{
                if GlobalVariables.sharedManager.fastingArray != nil{
                    unitsSold = GlobalVariables.sharedManager.fastingArray!
                    print(GlobalVariables.sharedManager.fastingArray!)
                }
            }
            else if selectedOption == "random"{
                if GlobalVariables.sharedManager.randomBpArray != nil{
                    unitsSold = GlobalVariables.sharedManager.randomBpArray!
                    print(GlobalVariables.sharedManager.randomBpArray!)
                }
            }
            else if selectedOption == "postPrandial"{
                if GlobalVariables.sharedManager.postPrandialArray != nil{
                    unitsSold = GlobalVariables.sharedManager.postPrandialArray!
                    print(GlobalVariables.sharedManager.postPrandialArray!)
                }
            }
            
            if unitsSold.count < 1{
                
                cell.chartViewOutlet.noDataText = "No data available!"
                cell.unitView.isHidden = true
            }
            else{
                
                cell.unitView.isHidden = false
                
                dataEntries = []
                for i in 0 ..< unitsSold.count {
                    let dataEntry = ChartDataEntry(x: Double(i), y: unitsSold[i]) // here we set the X and Y status in a data chart entry
                    dataEntries.append(dataEntry) // here we add it to the data set
                }
                
                let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units Consumed")
                
               /* lineChartDataSet.setCircleColor(UIColor.clear) // hide the outer circle color
                lineChartDataSet.circleRadius = 0.0
                lineChartDataSet.lineWidth = 2.0 //1.0
                lineChartDataSet.valueTextColor = UIColor.clear //hide the values on the curve line */
                
                lineChartDataSet.setCircleColor(UIColor.black) //setCircleColor(UIColor.clear) // hide the outer circle color
                lineChartDataSet.circleRadius = 3.0 //circleRadius = 0.0
                lineChartDataSet.lineWidth = 1.0 //1.0
                lineChartDataSet.valueTextColor = UIColor.black //hide the values on the curve line
                
                
                // to show line (curve line)
                lineChartDataSet.colors = [NSUIColor.blue] //Sets the line colour to blue
                lineChartDataSet.mode = .cubicBezier
                lineChartDataSet.cubicIntensity = 0.2
                
                var dataSets = [LineChartDataSet]() //This is the object that will be added to the chart
                dataSets.append(lineChartDataSet)  //Adds the line to the dataSet
                
                let lineChartData = LineChartData(dataSets: dataSets)
                cell.chartViewOutlet.data = lineChartData //finally - it adds the chart data to the chart and causes an update
                
                cell.chartViewOutlet.chartDescription?.text = "" //hide descriptionn label
                
                cell.chartViewOutlet.xAxis.enabled = true //show x axis
                cell.chartViewOutlet.leftAxis.enabled = true //show/hide left axix (Y axis)
                cell.chartViewOutlet.rightAxis.enabled = false //show/hide right axis (Y axis)
                cell.chartViewOutlet.animate(xAxisDuration: 1.5) //show animation
                cell.chartViewOutlet.drawGridBackgroundEnabled = true //show or hide background color
                //set in storyboard = #F3F4F8 or UIColor(red: 0.243, green: 0.244, blue: 0.248, alpha: 1)
                
                cell.chartViewOutlet.xAxis.drawGridLinesEnabled = true //it will show/hide grid background (Verticles lines - Y - form x axix)
                cell.chartViewOutlet.xAxis.drawAxisLineEnabled = true //show x axis line
                cell.chartViewOutlet.xAxis.labelPosition = .bottom // values/labels of x axis - position
                cell.chartViewOutlet.xAxis.drawLabelsEnabled = true //show/hide values/labels in x axis
                
                //right and left axis - optional/not required
                // chartViewOutlet.leftAxis.drawAxisLineEnabled = true //show lines of left x axis
                cell.chartViewOutlet.leftAxis.drawGridLinesEnabled = true //hide/show x axis grid lines - horizontal lines ( X axis - from Y)
                //  chartViewOutlet.rightAxis.drawAxisLineEnabled = false
                // chartViewOutlet.rightAxis.drawGridLinesEnabled = false
                
                cell.chartViewOutlet.legend.enabled = false //show.hide legend - below graph
                
                // swift 4.0 and lower versions
                let customFormater = CustomFormatter2()
                customFormater.labels =  months
                cell.chartViewOutlet.xAxis.valueFormatter = customFormater
                
                cell.chartViewOutlet.xAxis.labelRotationAngle = -45  // fixed label merging into others
                
                // this availabele after swift 4.2 or 5.0
                // chartViewOutlet.xAxis.valueFormatter = IndexAxisValueFormatter(values: months) //enable/show months label at x axis
                
                
                // Showing Limits and Showing dashed lines
                
                // x-axis limit line
                let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
                llXAxis.lineWidth = 1.5
                llXAxis.lineDashLengths = [10, 10, 0]
                llXAxis.labelPosition = .rightBottom
                llXAxis.valueFont = .systemFont(ofSize: 10)
                
                cell.chartViewOutlet.xAxis.gridLineDashLengths = [4, 4] // verticle line - dash lines
                cell.chartViewOutlet.xAxis.gridLineDashPhase = 0
                
                if selectedOption == "fasting"{
                    upperLimitValue = 100.0
                    lowerLimitValue = 70.0
                    axisMinValue = 30.0
                    axixMaxvalue = 400.0
                }
                else if selectedOption == "random"{
                    upperLimitValue = 160.0
                    lowerLimitValue = 70.0
                    axisMinValue = 30.0
                    axixMaxvalue = 400.0
                }
                else if selectedOption == "postPrandial"{
                    upperLimitValue = 140.0
                    lowerLimitValue = 70.0
                    axisMinValue = 30.0
                    axixMaxvalue = 400.0
                }
                
                let ll1 = ChartLimitLine(limit: upperLimitValue, label: "High") // limit the upper line
                ll1.lineWidth = 1.5
                ll1.lineColor = UIColor.red
                ll1.lineDashLengths = [4, 4]
                ll1.labelPosition = .rightTop
                ll1.valueFont = .systemFont(ofSize: 10)
                
                let ll2 = ChartLimitLine(limit: lowerLimitValue, label: "Low") // limit the lower line
                ll2.lineWidth = 1.5
                ll2.lineColor = UIColor.green
                ll2.lineDashLengths = [4,4]
                ll2.labelPosition = .rightBottom
                ll2.valueFont = .systemFont(ofSize: 10)
                
                let leftAxis = cell.chartViewOutlet.leftAxis
                leftAxis.removeAllLimitLines()
                leftAxis.addLimitLine(ll1)
                leftAxis.addLimitLine(ll2)
                leftAxis.axisMaximum = axixMaxvalue  //300 //highest values to show grph - y axis
                leftAxis.axisMinimum = axisMinValue //50// lowest values where graph has to start
                
                leftAxis.gridLineDashLengths = [5, 5] //horizontal line - dash lines
                leftAxis.drawLimitLinesBehindDataEnabled = true
            }
            
            return cell
        }
        else if indexPath.section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BloodSugarReportsCell2Id", for: indexPath) as! BloodSugarReportsCell2
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            
            cell.fastingButton.addTarget(self, action: #selector(fastingButtonAction(sender:)), for: .touchUpInside)
            cell.randomButton.addTarget(self, action: #selector(randomButtonAction(sender:)), for: .touchUpInside)
            cell.postPrandialButotton.addTarget(self, action: #selector(postPrandialButottonAction(sender:)), for: .touchUpInside)
           // cell.hba1cButton.addTarget(self, action: #selector(hba1cButtonAction(sender:)), for: .touchUpInside)
            
            if selectedOption == "fasting"{
                
                cell.fastingButton.setTitleColor(.white, for: .normal)
                cell.randomButton.setTitleColor(.black, for: .normal)
                cell.postPrandialButotton.setTitleColor(.black, for: .normal)
                //cell.hba1cButton.setTitleColor(.black, for: .normal)
                cell.fastingButton.backgroundColor = UIColor(red: 0.45, green: 0.75, blue: 0.26, alpha: 1)
                cell.randomButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
                cell.postPrandialButotton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
              //  cell.hba1cButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
            }
            else if selectedOption == "random"{
                
                cell.randomButton.setTitleColor(.white, for: .normal)
                cell.fastingButton.setTitleColor(.black, for: .normal)
                cell.postPrandialButotton.setTitleColor(.black, for: .normal)
               // cell.hba1cButton.setTitleColor(.black, for: .normal)
                cell.randomButton.backgroundColor = UIColor(red: 0.45, green: 0.75, blue: 0.26, alpha: 1)
                cell.fastingButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
                cell.postPrandialButotton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
               // cell.hba1cButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
            }
            else if selectedOption == "postPrandial"{
                
                cell.postPrandialButotton.setTitleColor(.white, for: .normal)
                cell.fastingButton.setTitleColor(.black, for: .normal)
                cell.randomButton.setTitleColor(.black, for: .normal)
              //  cell.hba1cButton.setTitleColor(.black, for: .normal)
                cell.postPrandialButotton.backgroundColor = UIColor(red: 0.45, green: 0.75, blue: 0.26, alpha: 1)
                cell.fastingButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
                cell.randomButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
               // cell.hba1cButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
            }
//            else if selectedOption == "hba1c"{
//
//                cell.hba1cButton.setTitleColor(.white, for: .normal)
//                cell.fastingButton.setTitleColor(.black, for: .normal)
//                cell.randomButton.setTitleColor(.black, for: .normal)
//                cell.postPrandialButotton.setTitleColor(.black, for: .normal)
//                cell.hba1cButton.backgroundColor = UIColor(red: 0.45, green: 0.75, blue: 0.26, alpha: 1)
//                cell.fastingButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
//                cell.randomButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
//                cell.postPrandialButotton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1)
//            }
            else{
                cell.fastingButton.setTitleColor(.black, for: .normal)
                cell.randomButton.setTitleColor(.black, for: .normal)
                cell.postPrandialButotton.setTitleColor(.black, for: .normal)
               // cell.hba1cButton.setTitleColor(.black, for: .normal)
            }
            
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BloodSugarReportsCell3Id", for: indexPath) as! BloodSugarReportsCell3
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            
            return 335.0
        }
        else if indexPath.section == 1{
            
            return 120.0
        }
        else{
            
            return 297.0
        }
        
    }
    
    
    @objc func fastingButtonAction(sender:UIButton){
        
        selectedOption = "fasting"
        mainTableView.reloadData()
    }
    
    @objc func randomButtonAction(sender:UIButton){
        
        selectedOption = "random"
        mainTableView.reloadData()
    }
    
    @objc func postPrandialButottonAction(sender:UIButton){
        
        selectedOption = "postPrandial"
        mainTableView.reloadData()
    }
    
   /* @objc func hba1cButtonAction(sender:UIButton){
        
        selectedOption = "hba1c"
        mainTableView.reloadData()
    } */
    
    //MARK: Notification call
    @objc func reloadLogRecords(notification: Notification) {
        
        if GlobalVariables.sharedManager.dateForBSArray != nil{
            
            months = GlobalVariables.sharedManager.dateForBSArray!
            
        }
        mainTableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("refreshChartDataValues1"), object: nil)
    }
    
}

final class CustomFormatter2: IAxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let count = self.labels.count
        
        guard let axis = axis, count > 0 else {
            return ""
        }
        
        let factor = axis.axisMaximum / Double(count)
        
        let index = Int((value / factor).rounded())
        
        if index >= 0 && index < count {
            return self.labels[index]
        }
        
        return ""
    }
}
