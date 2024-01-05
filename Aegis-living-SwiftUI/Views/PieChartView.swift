//
//  PieChartView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 04/01/24.
//

import SwiftUI
import DGCharts

struct PieChartUIView: UIViewRepresentable {
    var dataPoints: [String]
    var values: [Double]

    func makeUIView(context: Context) -> PieChartView {
        let pieChart = PieChartView()
        let m = pieChart.legend
        m.horizontalAlignment = .right
        m.verticalAlignment = .top
        m.orientation = .vertical
        m.yEntrySpace = 10
        m.font = m.font.withSize(7.5)
        pieChart.drawEntryLabelsEnabled = false
        pieChart.chartDescription.enabled = false
        pieChart.drawHoleEnabled = false
        pieChart.setExtraOffsets(left: 0, top: 0, right: 66, bottom: 0)
        pieChart.backgroundColor = UIColor.white
        pieChart.layer.cornerRadius = 10
        pieChart.noDataText = "No Data Available."
        pieChart.notifyDataSetChanged()
        return pieChart
    }

    func updateUIView(_ uiView: PieChartView, context: Context) {
        setPieChart(dataPoints: dataPoints, values: values, pieChartView: uiView)
    }
    
    private func setPieChart(dataPoints: [String], values: [Double], pieChartView: PieChartView) {
        // Your setPieChart function implementation here
        // This is the same function as mentioned in the previous example
        // Ensure you import Charts and implement the setPieChart function
        let filteredEntries = zip(dataPoints, values).compactMap { (dataPoint, value) -> PieChartDataEntry? in
               guard value != 0 else { return nil }
               return PieChartDataEntry(value: value, label: dataPoint)
           }
        
        let pieChartDataSet = PieChartDataSet(entries: filteredEntries, label: "")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartDataSet.drawValuesEnabled = false
        
        let colors: [UIColor] = [
            UIColor(red: (0.0/255.0), green: (124.0/255.0), blue: (193.0/255.0), alpha: 1.0),
            UIColor(red: (134.0/255.0), green: (196.0/255.0), blue: (73.0/255.0), alpha: 1.0),
            UIColor(red: (238.0/255.0), green: (64.0/255.0), blue: (47.0/255.0), alpha: 1.0),
            UIColor(red: (244.0/255.0), green: (129.0/255.0), blue: (50.0/255.0), alpha: 1.0),
            UIColor(red: (77.0/255.0), green: (63.0/255.0), blue: (152.0/255.0), alpha: 1.0),
            UIColor(red: (0.0/255.0), green: (180.0/255.0), blue: (230.0/255.0), alpha: 1.0),
            UIColor(red: (249.0/255.0), green: (192.0/255.0), blue: (68.0/255.0), alpha: 1.0)
        ]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        pieChartDataSet.colors = colors
        pieChartDataSet.sliceSpace = 1
        
        pieChartView.data = pieChartData
        pieChartView.notifyDataSetChanged()
    }
}
