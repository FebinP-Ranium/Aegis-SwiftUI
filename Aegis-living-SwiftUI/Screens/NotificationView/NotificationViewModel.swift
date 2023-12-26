//
//  NotificationViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 20/12/23.
//

import Foundation
import SwiftUI
final class NotificationViewModel:ObservableObject{
    let userManager = UserDataManager()
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published var notificatioList = [Notification]()
    @Published var isRefreshing = false

    
    func getNotification(){
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.NOTIFICATION, parameters: ["resident_id": userManager.residentId], modelType: NotificationListModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let eventModel):
                if let data = eventModel?.data{
                    self.notificatioList = data
                }
               
            case .failure(let error):
                switch error{
                case .invalidData:
                    self.alertItem = AlertContext.invalidData
                    
                case .invalidURL:
                    self.alertItem = AlertContext.invalidURL
                    
                case .invalidResponse:
                    self.alertItem = AlertContext.invalidData
                    
                case .unableToComplete:
                    self.alertItem = AlertContext.unableToComplete
                }
            }
            

        }
    }
    func deleteNotification(notificationId:Int){
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.DELETENOTIFICATION, parameters: ["resident_id": userManager.residentId,"community_notification_id":notificationId], modelType: NotificationListModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let eventModel):
                if let data = eventModel?.data{
                    self.notificatioList = data
                }
               
            case .failure(let error):
                switch error{
                case .invalidData:
                    self.alertItem = AlertContext.invalidData
                    
                case .invalidURL:
                    self.alertItem = AlertContext.invalidURL
                    
                case .invalidResponse:
                    self.alertItem = AlertContext.invalidData
                    
                case .unableToComplete:
                    self.alertItem = AlertContext.unableToComplete
                }
            }
            

        }
    }
    
    func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "hh:mma MMM dd, yyyy" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }
}