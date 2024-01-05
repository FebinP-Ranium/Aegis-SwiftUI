//
//  StackBarView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 04/01/24.
//

import SwiftUI
import DGCharts
struct StackedBarChart: UIViewRepresentable {
    @ObservedObject var viewModel: AttendenceViewModel
    func makeUIView(context: Context) -> BarChartView {
        lazy var formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            return formatter
        }()
        let barChartView = BarChartView()
        let leftAxis = barChartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        barChartView.chartDescription.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.backgroundColor = UIColor.white
        barChartView.layer.cornerRadius = 10
        barChartView.isUserInteractionEnabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        barChartView.legend.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.legend.enabled = false
        barChartView.isUserInteractionEnabled = true
        barChartView.chartDescription.enabled = true
        updateUIView(barChartView, context: context)
        let coordinator = self.makeCoordinator()
        coordinator.chartView = barChartView
        coordinator.timePeriod = viewModel.timePeriod
        coordinator.attendenceDetail = viewModel.attendenceDetail
        coordinator.attendanceStatusCount = viewModel.attendanceStatusCount
        barChartView.delegate = coordinator

        return barChartView
    }

    func updateUIView(_ barChartView: BarChartView, context: Context) {
        barChartView.data = createBarChart()
        configureAxisFormatters(dataPoints: viewModel.dataPoints, barChartView: barChartView)
    }

    private func createBarChart() -> BarChartData {
        var barChartEntries: [BarChartDataEntry] = []

        for i in 0..<viewModel.dataPoints.count {
            if viewModel.timePeriod == "week" {
                barChartEntries.append(BarChartDataEntry(x: Double(i), yValues: viewModel.values[i], icon:UIImage(named: "")))
            } else {
                guard let xValue = Double(viewModel.dataPoints[i]) else { continue }
                barChartEntries.append(BarChartDataEntry(x: xValue, yValues: viewModel.values[i]))
            }
        }

        let barChartDataSet = BarChartDataSet(entries: barChartEntries, label: "")
        let barChartColors = [ChartColors.blue, ChartColors.green, ChartColors.grey, ChartColors.darkBlue, ChartColors.orange, ChartColors.unavailable] // Choose colors or modify as needed
        barChartDataSet.colors = barChartColors

        let barChartData = BarChartData(dataSet: barChartDataSet)
        configureChartData(barChartData: barChartData)
        return barChartData
    }

    private func configureChartData(barChartData: BarChartData) {
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        barChartData.setValueFormatter(formatter)
        barChartData.setValueTextColor(.clear)
    }
    
    func configureAxisFormatters(dataPoints: [String], barChartView: BarChartView) {
        let xAxisValue = barChartView.xAxis
        let yAxisValue = barChartView.leftAxis
        
        xAxisValue.granularityEnabled = true
        xAxisValue.granularity = 1.0
        
        if viewModel.timePeriod == "week" {
            xAxisValue.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        } else {
            let valFormatter = NumberFormatter()
            valFormatter.numberStyle = .decimal
            valFormatter.maximumFractionDigits = 1
            xAxisValue.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        }
        
        yAxisValue.granularity = 1.0
    }
    class Coordinator: NSObject, ChartViewDelegate {
           var parent: StackedBarChart
           var chartView: BarChartView?
           var timePeriod:String?
           var attendanceStatusCount:[AttendanceStatusCount]?
           var attendenceDetail = [[Any]]()
           init(_ parent: StackedBarChart) {
               self.parent = parent
           }

           func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
               // Implement your logic when a value is selected here
               print("Selected value: \(entry)")
               
               guard let barEntry = entry as? BarChartDataEntry else { return }

               let stackIndex = highlight.stackIndex
               let doubleValue = barEntry.x
               let intValue = Int(doubleValue)

               let marker = BalloonMarker(color: UIColor.black, font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0))
               marker.minimumSize = CGSize(width: 75.0, height: 35.0)
               marker.widthOfView = chartView.bounds.width

               if timePeriod == "week" {
                   guard let dataForText = attendenceDetail[intValue][stackIndex] as? [StatusValue],
                         dataForText[0].intValue != 0 else {
                       chartView.marker = nil
                       return
                   }

                   let innerArray: [Any] = dataForText.compactMap { statusValue in
                       return statusValue.intValue ?? statusValue.stringValue
                   }

                   marker.text = getJoinedString(dataForText: innerArray)
                   chartView.marker = marker as? Marker
               } else {
                   let stringBarValue = (intValue < 10) ? String(format: "%02d", intValue) : String(intValue)

                   guard let index = attendanceStatusCount?.firstIndex(where: {
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "yyyy-MM-dd"
                       let event_date = $0.event_date ?? ""
                       let date = dateFormatter.date(from: event_date)!
                       let dateFormatter2 = DateFormatter()
                       dateFormatter2.dateFormat = "dd"
                       let currentDateString: String = dateFormatter2.string(from: date)
                       return currentDateString == stringBarValue
                   }), let dataForText = attendenceDetail[index][stackIndex] as? [StatusValue],
                   dataForText[0].intValue != 0 else {
                       chartView.marker = nil
                       return
                   }

                   let innerArray: [Any] = dataForText.compactMap { statusValue in
                       return statusValue.intValue ?? statusValue.stringValue
                   }

                   marker.text = getJoinedString(dataForText: innerArray)
                   chartView.marker = marker as? Marker
               }
               
               
               
               
           }
        
        func getJoinedString(dataForText: [Any]) -> String {
            var joinedString = ""

            if let secondElementString = dataForText[1] as? String {
                joinedString = secondElementString.replacingOccurrences(of: ", ", with: "\n")
                
            }
            if let thirdElement =  dataForText[2] as? String {
                joinedString = joinedString + "\n" + "(" + thirdElement + ")" + "\n"
            }
            return joinedString
        }

       }

       func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

    
}

