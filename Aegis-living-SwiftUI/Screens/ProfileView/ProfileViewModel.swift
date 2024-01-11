//
//  ProfileViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 05/01/24.
//

import Foundation
final class ProfileViewModel : ObservableObject{
    let userManager = UserDataManager()
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published var alertType:AlertType?
    @Published var oldPaswword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var showPswdChangeView : Bool = false

    func changePassword(){
        self.isLoading = true
        
        NetworkManager.shared.makePostRequest( Constants.CHANGEPSWD, parameters:["id":userManager.residentId,"current_password":oldPaswword,"new_password":newPassword,"confirm_password":newPassword], modelType: ChangePswdModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let changePasswordModel):
                if let pswdResponse = changePasswordModel?.response{
                    if pswdResponse == "success"{
                        self.alertItem = AlertContext.changePasswordSuccess
                        self.alertType = .passwordSuccess
                        self.showPswdChangeView = false
                        self.oldPaswword = ""
                        self.newPassword = ""
                        self.confirmPassword = ""
                    }
                    else{
                        self.alertItem = AlertContext.changePasswordNotSuccess
                        self.alertType = .passwordUnsuccessful
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
                case .invalidCredentials:
                    self.alertItem = AlertContext.invalidCredentials
                    self.alertType = .invalidCredentials
                }
            }
            

        }
    }
    func checkPasswordMatch(){
        if newPassword == confirmPassword{
            self.changePassword()
        }
        else{
            self.alertItem = AlertContext.changePasswordMisMatch
            self.alertType = .passwordMisMatch
        }
    }
}
