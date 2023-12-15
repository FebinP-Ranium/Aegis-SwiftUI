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
    @Published var isLoggedIn = true
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
    func callForLogout(){
        userManager.userLogout()
        isLoggedIn = userManager.isUserLoggedIn
    }
    
}
