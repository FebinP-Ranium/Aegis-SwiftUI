//
//  EngagementViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import Foundation
final class EngagementViewModel:ObservableObject{
    let userManager = UserDataManager()
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published var videoList = [String: [VideoData]]()
    @Published var videoType = [String]()
    func getVideoList(){
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.ENGAGEMENTVIDEO, parameters: [:], modelType: EngagementListModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let engagementModel):
                if let data = engagementModel?.data{
                    self.videoList = data
                    self.videoType.removeAll()
                }
                if let types = engagementModel?.types{
                    for item in types{
                        self.videoType.append(item)
                    }
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
}