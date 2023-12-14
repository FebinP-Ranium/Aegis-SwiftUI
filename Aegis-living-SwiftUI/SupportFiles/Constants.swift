//
//  Constants.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 14/12/23.
//

import Foundation
import UIKit

class Constants {
    
    //====================================
    //MARK:Prod API
    //====================================
//   static let HOST = "http://lifeenrichmenttracker.com/"
//    static let IMAGEURL = "http://df0l6ldaidrci.cloudfront.net"

    //====================================
    //MARK:Staging API
    //====================================
    
     static let USERHOST = "https://staging.lifeenrichmenttracker.com/"
    static let IMAGEURL = "https://d3fq18qucnsk6s.cloudfront.net"
    
    //====================================
    //MARK:api extention
    //====================================
    

    static let LOGINAPI = "family-auth"
   
    //====================================
    //MARK: API response text
    //====================================
    
    static let APISUCCESSTEXT = "success"
    static let INTERNETFAILCODE = 118
    static let INVALIDCREDENTIALS = "invalid_credentials"
    //====================================
    //MARK:Constants
    //====================================
    static let LIMIT = 10
    static let TIMERLIMIT = 30
    static let DEVICETYPE = "iOS"
  
    
    
    //====================================
    //MARK:Screen toast message
    //====================================
    static let INTERNET = "Check your internet connection."
    static let SERVERERROR = "Server Error, Please Try later"
    static let DATAEMPTYERROR = "Data not available"
    
    //====================================
    //MARK:APPSTORAGE constants
    //====================================
    
    static let COMMUNITYNAME = "communityName"
    static let COMMUNITYID = "communityId"
    static let RESIDENTID = "residentId"
    static let ROOM = "room"
    static let FIRSTNAME = "firstName"
    static let LASTNAME = "lastName"
    static let IMAGE = "image"
    static let ISUSERLOGGEDIN = "isUserLoggedIn"
    static let AUTHTOKEN = "AuthToken"
    static let SHOWATTENDANCE = "showAttendance"
    static let HASPARTNER = "hasPartner"

    
}
