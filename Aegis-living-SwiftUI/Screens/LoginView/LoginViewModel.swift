//
//  LoginViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 14/12/23.
//

import Foundation
final class LoginViewModel:ObservableObject{
    @Published var userName = ""
    @Published var password = ""
    @Published var isShowResidentView = false
    @Published var alertItem:AlertItem?
    @Published var isLoading = false
    @Published var rootpresentng:Bool = false
    @Published var alertType:AlertType?


    let userManager = UserDataManager()
    func loginUser() {
        
        if self.userName == "" || self.password == ""{
            self.alertItem = AlertContext.invalidLoginDetails
            return
        }
        
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.LOGINAPI, parameters: ["email":userName,"password":password], modelType: LoginModel.self, isHeader: false){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let loginResponse):
                if let loginResponse = loginResponse{
                    self.userManager.saveUserData(loginResponse)
                    self.isShowResidentView = true
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
    
    func handleDismiss() {
           // Check if the dismiss action exists and call it
        self.userName = ""
        self.password = ""
       }
    
    func checkForLogin(){
        self.isShowResidentView = userManager.isUserLoggedIn
    }
    
}
