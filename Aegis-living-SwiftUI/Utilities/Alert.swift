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
    let title:Text
    let message:Text
    let dismissButtonText:Text
}
struct AlertContext{
    /// ////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Network Alert
    /// ////////////////////////////////////////////////////////////////////////////////////////
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
}

