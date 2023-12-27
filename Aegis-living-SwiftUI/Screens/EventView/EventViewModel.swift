//
//  EventViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 19/12/23.
//

import Foundation
final class EventViewModel:ObservableObject{
    let userManager = UserDataManager()
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published var dateString = ""
    @Published var eventDataList = [EventDataItem]()
    @Published var alertType:AlertType?


    func getEvent(){
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.EVENTLIST, parameters: ["date": "\(dateString)","id": userManager.residentId], modelType: EventListModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let eventModel):
                if let data = eventModel?.data{
                    self.eventDataList = data
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
    
    func updateDateByAdding(value:Int){

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        guard let date = dateFormatter.date(from: dateString) else { return }

        let modifiedDate = Calendar.current.date(byAdding: .day, value: value, to: date)!
        let modifiedDateString = dateFormatter.string(from: modifiedDate)
        dateString = modifiedDateString
        getEvent()
    }
    func getTodaysDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        let currentDateString: String = dateFormatter.string(from: date)
        dateString = currentDateString
    }
    
}
