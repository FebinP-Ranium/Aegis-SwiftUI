//
//  EngagementViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import Foundation
import SwiftUI
final class EngagementViewModel:ObservableObject{
    let userManager = UserDataManager()
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published var alertType:AlertType?

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
}
