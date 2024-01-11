//
//  ResidentViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 15/12/23.
//

import Foundation
import SwiftUI
final class ResidentViewModel:ObservableObject{
    
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published var categoryName:CategoryName?
    @Published var isActiveCategory = false
    @Published var alertType:AlertType?

    let userManager = UserDataManager()

    
    func switchUser(id:Int){
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.SWITCHACCOUNT, parameters: ["id":id], modelType: ResidentModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let residentModel):
                if let residentModel = residentModel{
                    self.userManager.saveResidentData(residentModel.data)
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
    func callForLogout(){
        userManager.userLogout()
    }
   
    @ViewBuilder
    func getViewForCategory() -> some View {
        if let categoryName = categoryName {
            switch categoryName {
            case .events:
                EventView()
            case .photos:
                PhotosView()
            case .lifeStory:
               LifeStoryView()
            case .attendeance:
                AttendenceView()
            case .engagement:
                EngangementView()
            case .notification:
               NotificationView()
            }
        } else {
            EmptyView()
        }
    }
}
