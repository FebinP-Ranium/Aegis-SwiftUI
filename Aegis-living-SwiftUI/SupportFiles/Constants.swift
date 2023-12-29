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
    static let SWITCHACCOUNT = "familylink/v1/residents/index"
    static let EVENTLIST = "familylink/v1/residents/events"
    static let NOTIFICATION = "familylink/v1/get-notifications"
    static let DELETENOTIFICATION = "familylink/v1/notifications/delete"
    static let ENGAGEMENTVIDEO = "familylink/v1/engagement-videos"
    static let GALLERY = "familylink/v1/residents/gallery"
    static let UPLOAD = "familylink/v1/family-upload"
    static let DELETEPHOTO = "familylink/v1/resident-photo/delete"
    static let UPLOADPROFILEPIC = "familylink/v1/residents/set-profile"
    static let LIFESTORY = "familylink/v1/residents/life-story"
    static let SAVELIFESTORY = "familylink/v1/life-story/save"

   
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
    
    static let P_COMMUNITYNAME = "p_communityName"
    static let P_COMMUNITYID = "p_communityId"
    static let P_RESIDENTID = "p_residentId"
    static let P_ROOM = "p_room"
    static let P_FIRSTNAME = "p_firstName"
    static let P_LASTNAME = "p_lastName"
    static let P_IMAGE = "p_image"
    static let P_SHOWATTENDANCE = "p_showAttendance"
    

    
}
