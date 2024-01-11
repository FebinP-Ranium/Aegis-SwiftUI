//
//  LifestoryViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 28/12/23.
//

import Foundation
import SwiftyJSON
import SwiftUI
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
    @Published var textsForMemoirAnswer: [String] = []
    @Published var textsForResidentQuestion: [String] = []
    @Published var textsForResidentAnswer: [String] = []
    @Published var tempMemoirquestion = MemoirQuestions(id: -1, answer: .string("Temp Question"), question: .string("Temp Answer"))
    @Published var memoirType:MemoirType?
    @Published var memoirAnswer:[MemoirQuestions]?
    @Published var residentQueston:[MemoirQuestions]?

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
                    
                    if let memoirAnswer = self.memoirData?.memoirs?.memoirs{
                        self.memoirAnswer = memoirAnswer
                        for _ in 0..<memoirAnswer.count {
                            // Simulating fetched text (replace this with your API response)
                            self.textsForMemoirAnswer.append("")
                        }
                    }
                    if let residentQueston = self.memoirData?.memoirs?.resident_memoirs{
                        self.residentQueston = residentQueston
                        for _ in 0..<residentQueston.count {
                            // Simulating fetched text (replace this with your API response)
                            self.textsForResidentAnswer.append("")
                            self.textsForResidentQuestion.append("")

                        }
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
                case .apiError(let errorMessage):
                    self.alertItem = AlertItem(title: Text("Error"),
                                            message:  Text(errorMessage),
                                            dismissButtonText: Text("OK"))
                    self.alertType = .apiError
               
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
                case .apiError(let errorMessage):
                    self.alertItem = AlertItem(title: Text("Error"),
                                            message:  Text(errorMessage),
                                            dismissButtonText: Text("OK"))
                    self.alertType = .apiError
                }
            }
            

        }
    }
    func saveMemoirData(key:String,value:Any,key2:String,value2:Any,id:Any){
        self.isLoading = true
        
        var parameters = [key:
                            value,"resident_id":
                            userManager.residentId,key2:value2] as [String : Any]
        if (id as! Int != 0)
        {
            parameters.updateValue(id, forKey: "id")
        }
       
        
        NetworkManager.shared.makePostRequest( Constants.MEMOIRDATASAVE, parameters:parameters, modelType: MemoirSaveResponse.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let memoirData):
                if let data = memoirData?.memoir{
                    self.memoirAnswer = data.memoirs
                    self.residentQueston = data.resident_memoirs

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
                case .apiError(let errorMessage):
                    self.alertItem = AlertItem(title: Text("Error"),
                                            message:  Text(errorMessage),
                                            dismissButtonText: Text("OK"))
                    self.alertType = .apiError
                }
            }
            

        }
    }
    
    func getResidentQuestion(index:Int)->String{
        var question = ""
        if let stringValue = self.memoirData?.memoirs?.memoirs?[index].question?.stringValue() {
            question = stringValue
        } else if let intValue = self.memoirData?.memoirs?.memoirs?[index].question?.intValue(){
            question = "\(intValue)"
        }
        else{
            question = ""
        }
        return question
        
    }
}
