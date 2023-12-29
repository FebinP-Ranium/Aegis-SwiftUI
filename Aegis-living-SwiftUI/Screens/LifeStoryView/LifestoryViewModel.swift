//
//  LifestoryViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 28/12/23.
//

import Foundation
import SwiftyJSON

final class LifeStoryViewModel:ObservableObject{
    let userManager = UserDataManager()
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published var alertType:AlertType?
    @Published var memoirData:MemoirData?
    @Published var sectionNames = [ "Top 10 things to know about me", "Music Preferences","Memoirs", "Additional Information"];
    @Published var textValue: [String] = ["","","","","","","","","",""]
    @Published var topThingData : [TopThing]?
    @Published var musicHintText = "Please add any song titles, genres of music, or specific artists here."
    @Published var additionalInfoHint = "Additional Information"

    func getLiveStoryData(){
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.LIFESTORY, parameters:["resident_id":
                                                                                    userManager.residentId], modelType: LiveStoryResponse.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let lifeStorYresponse):
                if let data = lifeStorYresponse?.data{
                    self.memoirData = data
                    if let  topThingData = data.top_things{
                        self.topThingData = topThingData
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
    func saveLiveStoryData(type:String,value:Any){
        self.isLoading = true
       
        
        NetworkManager.shared.makePostRequest( Constants.SAVELIFESTORY, parameters:["resident_id":
                                                                                    userManager.residentId,type:value], modelType: LiveStoryResponse.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let lifeStorYresponse):
                if let data = lifeStorYresponse?.data{
                    if let topThingsNote = data.top_things {
                        self.topThingData = topThingsNote
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
    
    func checkValueType(_ value: Any)->String {
        if value is Int {
            print("Value is an Int")
            let intVal = String(format: "%@", value as! CVarArg)
            return intVal
        } else if value is String {
            print("Value is a String")
            return value as! String
        } else {
            print("Value is of another type")
            return ""
        }
    }
}
