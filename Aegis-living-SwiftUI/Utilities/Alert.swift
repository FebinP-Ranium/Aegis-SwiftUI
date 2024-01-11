//
//  Alert.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 14/12/23.
//

import Foundation
import SwiftUI
struct AlertItem:Identifiable{
    let id = UUID()
       let title: Text
       let message: Text
       let primaryButton: Text // Primary button
       let secondaryButton: Text? // Optional secondary button
    
      init(title: Text, message: Text, dismissButtonText: Text) {
            self.title = title
            self.message = message
            self.primaryButton = dismissButtonText
            self.secondaryButton = nil
        }

        init(title: Text, message: Text, primaryButton: Text, secondaryButton: Text) {
            self.title = title
            self.message = message
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
        }
}
struct AlertContext{
    /// ////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Network Alert
    /// ////////////////////////////////////////////////////////////////////////////////////////
    /// 
    static let invalidData = AlertItem(title: Text("Server Error"),
                                       message: Text("The data recieved from server is invalid"),
                                              dismissButtonText: Text("OK"))
    static let invalidRespone = AlertItem(title: Text("Server Error"),
                                          message: Text("Invalid response from the server. Please try again later "),
                                           dismissButtonText: Text("OK"))
    static let invalidURL = AlertItem(title: Text("Server Error"),
                                      message: Text("Please check the url"),
                                           dismissButtonText: Text("OK"))
    static let unableToComplete = AlertItem(title: Text("Internet Issue"),
                                            message: Text("Unable to complete the request, please check internet"),
                                           dismissButtonText: Text("OK"))
  
    
    /// ////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Account Alert
    /// ////////////////////////////////////////////////////////////////////////////////////////
    static let invalidLoginDetails = AlertItem(title: Text("User Alert"),
                                               message: Text("Email and Password is required"),
                                           dismissButtonText: Text("OK"))
    static let invalidCredentials = AlertItem(title: Text("Invalid Credentials"),
                                              message: Text("Please ensure credentials are valid"),
                                           dismissButtonText: Text("OK"))
    static let successfullSaved = AlertItem(title: Text("Saved Changes"),
                                            message: Text("All datas saved successfully"),
                                           dismissButtonText: Text("OK"))
    static let unSuccesfulLogin = AlertItem(title: Text("User Alert"),
                                            message: Text("Not able to login, Please try after sometime"),
                                           dismissButtonText: Text("OK"))
    
    /// ////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - common alert
    /// ////////////////////////////////////////////////////////////////////////////////////////
    
    static let nullDataAlert = AlertItem(title: Text("Server Error"),
                                            message: Text(""),
                                           dismissButtonText: Text("OK"))
    /// ////////////////////////////////////////////////////////////////////////////////////////
    // MARK: -image upload successful alert
    /// ////////////////////////////////////////////////////////////////////////////////////////
    
    static let imageSuccessFullAlert = AlertItem(title: Text("Image Upload"),
                                            message: Text("Image successfully uploaded. It may take a moment to process."),
                                           dismissButtonText: Text("OK"))
    static let noDeleteAlert = AlertItem(title: Text("Delete Alert"),
                                            message: Text("This photo cannot be deleted."),
                                           dismissButtonText: Text("OK"))
    static let deleteConfirmationAlert =  AlertItem(title: Text("Delete Alert"),
                                              message: Text("Are you sure you want to delete the photo?"),
                                              primaryButton: Text("Delete"),
                                              secondaryButton: Text("Cancel"))
    
    static let setprofilePicAlert = AlertItem(title: Text("Image Upload"),
                                            message: Text("Profile picture uploaded successfully"),
                                           dismissButtonText: Text("OK"))
    
    
    
    /// ////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Change Password
    /// ////////////////////////////////////////////////////////////////////////////////////////
    
    
    static let changePasswordSuccess = AlertItem(title: Text("Change Password Alert"),
                                            message: Text("Password has been changed successfully."),
                                           dismissButtonText: Text("OK"))
    static let changePasswordMisMatch = AlertItem(title: Text("Change Password Alert"),
                                            message: Text("Passwords does not match"),
                                           dismissButtonText: Text("OK"))
    static let changePasswordNotSuccess = AlertItem(title: Text("Change Password Alert"),
                                            message: Text("Password not changed."),
                                           dismissButtonText: Text("OK"))
}

