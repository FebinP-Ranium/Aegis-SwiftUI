//
//  AttendenceViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 02/01/24.
//

import Foundation
import DGCharts
final class AttendenceViewModel:ObservableObject{
    let userManager = UserDataManager()
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published var alertType:AlertType?
    @Published var timePeriod = "month"
    @Published var isWeek = false
    @Published var dateValue:String?
    @Published var prevDate:String?
    @Published var nextDate:String?
    @Published var locked = false
    @Published var eventDatas : [EventDate]?
    @Published var barChartEntries: [BarChartDataEntry] = []
    @Published var barChartColors = [ChartColors.blue, ChartColors.green, ChartColors.grey, ChartColors.darkBlue, ChartColors.orange, ChartColors.unavailable]
    @Published var dataPoints: [String] = [""]
    @Published var values: [[Double]] = [[0.0]]
    
    @Published var pieChartLabel : [String] = [""]
    @Published var pieChartValues : [Double] = [0.0]
    @Published var attendanceStatusCount:[AttendanceStatusCount]?
    @Published var attendenceDetail = [[Any]]()
    
    func getAttendenceList(date:String){
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.ATTENDENCE, parameters:["start":date,"residentId": userManager.residentId ,"timePeriod":self.timePeriod,"android":true,"unavailable":true], modelType: AttendenceListModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let attendenceData):
                if let attendenceData = attendenceData?.data{
                    if let dateRanges = attendenceData.date_ranges{
                        self.dateValue = dateRanges.title ?? ""
                        self.prevDate = dateRanges.prev ?? ""
                        self.nextDate = dateRanges.next ?? ""
                        self.locked = dateRanges.locked ?? false
                        self.eventDatas = attendenceData.event_dates
                    }
                    if let attendanceStatusCount = attendenceData.attendance_status_count{
                        self.attendanceStatusCount = attendanceStatusCount
                        self.setAttendanceData(attendanceStatusCount: attendanceStatusCount)
                    }
                    if let dimensionsAverage = attendenceData.dimensionsaverage{
                       // self.legentBarHtCnst.constant = 100
                        self.setPieChartData(dimensionsAverage: dimensionsAverage)
                       // self.setPieChart(dataPoints: labelData, values: values)
                    }
                }
               
               
            case .failure(let error):
                switch error{
                case .invalidData:
                    self.alertItem = AlertContext.invalidData
                    self.alertType = .invalidData
                case .invalidURL:
                    self.alertItem = AlertContext.invalidURL
                    self.alertType = .invalidURL
                case .invalidResponse:
                    self.alertItem = AlertContext.invalidData
                    self.alertType = .invalidData
                case .unableToComplete:
                    self.alertItem = AlertContext.unableToComplete
                    self.alertType = .unableToComplete
                }
            }
            

        }
    }
    func formatDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateFormat1 = dateFormatter.date(from: dateString)
        if let newDate = newDateFormat1{
            dateFormatter.dateFormat = "MM/dd"
            let newDateFormat2 = dateFormatter.string(from: newDate)
            
            return newDateFormat2
        }
        else{
            return "N/A"
        }
    }
    
    func setAttendanceData(attendanceStatusCount:[AttendanceStatusCount]){
        
        
        var barData = [[Double]]()
        var barLabel = [String]()
        self.attendenceDetail.removeAll()

        for data in attendanceStatusCount {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let eventDate = data.event_date, let date = dateFormatter.date(from: eventDate) {
                let dateFormatterDay = DateFormatter()
                dateFormatterDay.dateFormat = "dd"
                let currentDateString = dateFormatterDay.string(from: date)
                var count = [Double]()
                var firstElements = [Any]()

                if let resData = data.attendance_status {
                for status in resData{
                    if let firstElement = status.first?.intValue {
                        firstElements.append(firstElement)
                    }

                }
                count = firstElements.compactMap { Double(String(describing: $0)) }

                }
                
                if let resData = data.attendance_status  {
                self.attendenceDetail.append(resData)
                }
                barData.append(count)
                barLabel.append(currentDateString)
            }
        }
        
        print(barData)
        print(barLabel)
        dataPoints = barLabel
        values = barData
        

    }
    func setPieChartData(dimensionsAverage: DimensionsAverage){
        self.pieChartLabel = [
            "\(dimensionsAverage.professional ?? 0.0)% PROFESSIONAL",
            "\(dimensionsAverage.physical ?? 0.0)% PHYSICAL",
            "\(dimensionsAverage.spiritual ?? 0.0)% SPIRITUAL",
            "\(dimensionsAverage.emotional ?? 0.0)% EMOTIONAL",
            "\(dimensionsAverage.intellectual ?? 0.0)% INTELLECTUAL",
            "\(dimensionsAverage.environmental ?? 0.0)% ENVIRONMENTAL",
            "\(dimensionsAverage.social ?? 0.0)% SOCIAL"
        ]
        self.pieChartValues = [
            dimensionsAverage.professional ?? 0.0,
            dimensionsAverage.physical ?? 0.0,
            dimensionsAverage.spiritual ?? 0.0,
            dimensionsAverage.emotional ?? 0.0,
            dimensionsAverage.intellectual ?? 0.0,
            dimensionsAverage.environmental ?? 0.0,
            dimensionsAverage.social ?? 0.0
        ]
    }
}
